class SearchResult < ActiveRecord::Base
  belongs_to :search
  validates_uniqueness_of :url
  
  class << self
    def per_page
      15
    end
    
    def latest(options)
      conditions_str = []
      conditions_arg = []
      
      unless options[:brand_id].blank?
        conditions_str << "brands.id = ?"
        conditions_arg << options[:brand_id]
      end

      unless options[:source].blank?
        conditions_str << "search_results.source = ?"
        conditions_arg << options[:source]
      end

      unless options[:flag].blank?
        conditions_str << "search_results.follow_up = 1"
      end
      
      conditions = [conditions_str.join(' AND '), *conditions_arg]
      
      paginate(
        :page => options[:page],
        :order => "search_results.created_at DESC",
        :include => [ :search => :brands ],
        :conditions => conditions)
    end  
  end

  def toggle_follow_up
    update_attribute(:follow_up, !follow_up?)
  end
end
