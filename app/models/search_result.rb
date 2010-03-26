# == Schema Information
#
# Table name: search_results
#
#  id        :integer(4)      not null, primary key
#  query_id  :integer(4)      indexed => [result_id], indexed
#  result_id :integer(4)      indexed => [query_id], indexed
#

class SearchResult < ActiveRecord::Base
  belongs_to :query
  belongs_to :result
end
