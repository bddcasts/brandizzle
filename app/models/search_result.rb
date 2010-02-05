class SearchResult < ActiveRecord::Base
  belongs_to :query
  belongs_to :result
end