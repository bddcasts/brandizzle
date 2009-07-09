class Search < ActiveRecord::Base
  validates_presence_of :term
  belongs_to :brand
  has_many :results, :class_name => "SearchResult", :foreign_key => "search_id"
  
  class << self
    def run_against_twitter
      searches = Search.find(:all)
      searches.each do |search|
        Twitter::Search.new(search.term).fetch().results.each do |result|
          search.results.create(
            :source => 'twitter',
            :created_at => result["created_at"],
            :body => result["text"],
            :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"
          )
        end
      end
    end
  end
end
