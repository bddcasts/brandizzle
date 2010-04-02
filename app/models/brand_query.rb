# == Schema Information
#
# Table name: brand_queries
#
#  id       :integer(4)      not null, primary key
#  brand_id :integer(4)      indexed => [query_id], indexed
#  query_id :integer(4)      indexed => [brand_id], indexed
#

class BrandQuery < ActiveRecord::Base
  belongs_to :brand
  belongs_to :query
end

