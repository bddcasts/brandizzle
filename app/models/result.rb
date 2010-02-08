class Result < ActiveRecord::Base
  has_many :search_results
  has_many :queries, :through => :search_results
  has_many :brand_results
  has_many :brands, :through => :brand_results
end
