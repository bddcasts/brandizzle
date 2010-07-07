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

class UserDetail < ActiveRecord::Base
  belongs_to :user
end
