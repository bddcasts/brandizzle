class Search < ActiveRecord::Base
  validates_presence_of :term
  belongs_to :brand
  has_many :results, :class_name => "SearchResult", :foreign_key => "search_id"
  
  class << self
    def run_against_twitter
      searches = Search.find(:all)
      searches.each do |search|
        search.run_against_twitter
      end
    end
  end
  
  def run_against_twitter
    twitter_search = latest_id.blank? ? Twitter::Search.new(term) : Twitter::Search.new(term).since(latest_id)
    twitter_results = twitter_search.fetch().results
    
    max_id = 0
    twitter_results.each do |result|
      max_id = [result["id"], max_id].max
      results.create(
        :source => 'twitter',
        :created_at => result["created_at"],
        :body => result["text"],
        :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"
      )
    end
    
    if latest_id.blank? || max_id > latest_id.to_i
      self.latest_id = max_id 
      save
    end
  end
end
