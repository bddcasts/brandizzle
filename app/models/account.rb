# == Schema Information
#
# Table name: accounts
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  invitation_id :string(255)
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  belongs_to :invitation
  has_one :team
  
  accepts_nested_attributes_for :holder
  
  validates_presence_of :holder
  validates_associated :holder
  validates_presence_of :invitation_id, :message => 'Invitation is required'
  validates_uniqueness_of :invitation_id, :message => 'Invitation has already been used'
end
