class Search < ActiveRecord::Base
  validates_presence_of :term
  has_and_belongs_to_many :brands
  has_and_belongs_to_many :results

  class << self
    def run
      searches = Search.find(:all)
      searches.each do |search|
        search.run_against_twitter
        search.run_against_blog_search
      end
    end
  end
  
  def run_against_twitter
    twitter_search = latest_id.blank? ? Twitter::Search.new(term) : Twitter::Search.new(term).since(latest_id)
    twitter_results = twitter_search.fetch().results
    
    max_id = 0
    twitter_results.each do |result|
      max_id = [result["id"], max_id].max
      options = {
        :source => 'twitter',
        :created_at => result["created_at"],
        :body => result["text"],
        :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"      
      }
      
      r = Result.find_or_create_by_url(options)
      results << r unless results.include?(r)
    end
    
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
    json_results["responseData"]["results"].each do |r|

      options = {
        :source => 'blog',
        :body => r["content"],
        :created_at => r["publishedDate"],
        :url => r["postUrl"]
      }
      
      r = Result.find_or_create_by_url(options)
      results << r unless results.include?(r)
    end
    
    if start == 0
      json_results["responseData"]["cursor"]["pages"].each do |p|
        pages << p["start"].to_i unless p["start"] == "0"
      end  
    end
    
    pages
  end
end
