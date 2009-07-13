class SearchResult < ActiveRecord::Base
  belongs_to :search
  
  class << self
    def per_page
      15
    end
    
    def latest(options)
      paginate(:page => options[:page], :order => "search_results.created_at DESC")
    end  
  end
end
