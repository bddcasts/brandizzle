# == Schema Information
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  has_one :team
  
  accepts_nested_attributes_for :holder
  
  validates_presence_of :holder
  validates_associated :holder
end
