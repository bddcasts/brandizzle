# == Schema Information
#
# Table name: search_results
#
#  id        :integer(4)      not null, primary key
#  query_id  :integer(4)      indexed, indexed => [result_id]
#  result_id :integer(4)      indexed, indexed => [query_id]
#

class SearchResult < ActiveRecord::Base
  belongs_to :query
  belongs_to :result
end

