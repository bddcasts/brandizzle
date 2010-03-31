# == Schema Information
#
# Table name: teams
#
#  id          :integer(4)      not null, primary key
#  account_id  :integer(4)
#  users_count :integer(4)      default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

class Team < ActiveRecord::Base
  has_many :members, :class_name => "User"
  has_many :brands
  has_many :brand_results, :through => :brands
  belongs_to :account
end
