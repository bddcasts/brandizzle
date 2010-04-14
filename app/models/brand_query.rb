# == Schema Information
#
# Table name: brand_queries
#
#  id       :integer(4)      not null, primary key
#  brand_id :integer(4)      indexed, indexed => [query_id]
#  query_id :integer(4)      indexed, indexed => [brand_id]
#

class BrandQuery < ActiveRecord::Base
  belongs_to :brand
  belongs_to :query
end

