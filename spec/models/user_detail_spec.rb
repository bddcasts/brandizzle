# == Schema Information
#
# Table name: user_details
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  twitter_screen_name :string(255)
#  twitter_location    :string(255)
#  email_updates       :boolean(1)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe UserDetail do
  #columns
  should_have_column :twitter_screen_name, :twitter_location, :type => :string
  should_have_column :email_updates, :type => :boolean
  
  #associations
  should_belong_to :user
end
