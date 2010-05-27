# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer(4)      not null, primary key
#  plan_id         :string(255)
#  account_id      :integer(4)      indexed
#  subscription_id :integer(4)
#  card_token      :string(255)
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Subscription do
  before(:each) do
    @valid_attributes = {
      :plan_id => "value for plan_id",
      :account_id => 1,
      :subscription_id => 1,
      :status => "value for status"
    }
  end

  it "should create a new instance given valid attributes" do
    Subscription.create!(@valid_attributes)
  end
end
