# == Schema Information
#
# Table name: search_results
#
#  id        :integer(4)      not null, primary key
#  query_id  :integer(4)      indexed, indexed => [result_id]
#  result_id :integer(4)      indexed, indexed => [query_id]
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchResult do
  #associations
  should_belong_to :result
  should_belong_to :query
end

