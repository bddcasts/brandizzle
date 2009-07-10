class SearchResult < ActiveRecord::Base
  belongs_to :search
  
  named_scope :latest, :order => "search_results.created_at DESC"
end
