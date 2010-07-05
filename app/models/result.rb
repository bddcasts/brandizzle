# == Schema Information
#
# Table name: results
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  source     :string(255)
#  url        :string(255)     indexed
#  created_at :datetime        indexed
#  updated_at :datetime
#

class Result < ActiveRecord::Base
  has_many :search_results
  has_many :queries, :through => :search_results
  has_many :brand_results
  has_many :brands, :through => :brand_results
  
  def twitter?
    source == "twitter"
  end
  
  def add_brand(brand)
    brand_results.create(:brand => brand, :team => brand.team, :result_created_at => created_at) unless brands.include?(brand)
  end
end
