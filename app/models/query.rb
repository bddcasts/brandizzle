# == Schema Information
#
# Table name: queries
#
#  id         :integer(4)      not null, primary key
#  term       :string(255)
#  latest_id  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Query < ActiveRecord::Base
  validates_presence_of :term
  has_many :brand_queries
  has_many :brands, :through => :brand_queries
  
  has_many :search_results
  has_many :results, :through => :search_results

  class << self
    def run
      queries = Query.find(:all)
      queries.each do |query|
        query.run_against_twitter
        query.run_against_blog_search
      end
    end
  end
  
  def run_against_twitter
    twitter_search = latest_id.blank? ? Twitter::Search.new(term) : Twitter::Search.new(term).since(latest_id)
    twitter_results = twitter_search.fetch().results
    
    max_id = 0
    returned_results = twitter_results.map do |result|
      max_id = [result["id"], max_id].max
      options = {
        :source => 'twitter',
        :created_at => result["created_at"],
        :body => result["text"],
        :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"      
      }
      
      returned_result = Result.find_or_create_by_url(options)
      results << returned_result unless results.include?(returned_result)
      
      returned_result
    end
    
    self.send_later(:link_brand_results, returned_results.map(&:id))
    
    if latest_id.blank? || max_id > latest_id.to_i
      self.latest_id = max_id 
      save
    end
  end
  
  def run_against_blog_search
    pages = [0]
    loop do
      start = pages.pop
      url = "http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=#{URI.escape(term)}&rsz=large&start=#{start}"

      pages.concat(parse_response(open(url).read, start))
      
      break if pages.empty?      
    end
  end
  
  def parse_response(response, start)
    pages = []
    
    json_results = JSON.parse(response)
    returned_results = json_results["responseData"]["results"].map do |r|

      options = {
        :source => 'blog',
        :body => r["content"],
        :created_at => r["publishedDate"],
        :url => r["postUrl"]
      }
      
      returned_result = Result.find_or_create_by_url(options)
      results << returned_result unless results.include?(returned_result)
      
      returned_result
    end
    
    self.send_later(:link_brand_results, returned_results.map(&:id))
    
    if start == 0
      json_results["responseData"]["cursor"]["pages"].each do |p|
        pages << p["start"].to_i unless p["start"] == "0"
      end  
    end
    
    pages
  end

  def link_brand_results(returned_results_ids)
    returned_results = Result.find(returned_results_ids)
    
    returned_results.each do |returned_result|
      brands.each do |brand|
        returned_result.brands << brand unless returned_result.brands.include?(brand)
      end
    end
  end
  
  def to_s
    term
  end
end
