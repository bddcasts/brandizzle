# == Schema Information
#
# Table name: logs
#
#  id                  :integer(4)      not null, primary key
#  loggable_id         :integer(4)      indexed => [loggable_type]
#  loggable_type       :string(255)     indexed => [loggable_id]
#  user_id             :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  loggable_attributes :text
#

require 'spec_helper'

describe Log do
  #columns
  should_have_column :loggable_type, :type => :string
  should_have_column :loggable_attributes, :type => :text
  
  #associations
  should_belong_to :user
  should_belong_to :loggable, :polymorphic => true
end
