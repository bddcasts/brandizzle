# == Schema Information
#
# Table name: brand_queries
#
#  id       :integer(4)      not null, primary key
#  brand_id :integer(4)      indexed, indexed => [query_id]
#  query_id :integer(4)      indexed, indexed => [brand_id]
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BrandQuery do
  #associations
  should_belong_to :brand
  should_belong_to :query
end

