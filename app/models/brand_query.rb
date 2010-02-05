class BrandQuery < ActiveRecord::Base
  belongs_to :brand
  belongs_to :query
end