# == Schema Information
#
# Table name: teams
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Team < ActiveRecord::Base
  has_many :members, :class_name => "User"
  has_many :brands
  has_many :brand_results
  has_many :logs
  has_many :comments
  belongs_to :account
  
  def total_search_terms
    brands.to_a.sum(&:brand_queries_count)
  end
  
  def members_count
    members.size
  end
end
