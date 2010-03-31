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

require 'spec_helper'

describe Team do
  #columns
  should_have_column :users_count, :type => :integer
  
  #associations
  should_have_many :members, :class_name => "User"
  should_have_many :brands
  should_have_many :brand_results, :through => :brands
  should_belong_to :account
end
