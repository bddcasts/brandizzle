# == Schema Information
#
# Table name: subscription_transactions
#
#  id                        :integer(4)      not null, primary key
#  account_id                :integer(4)      indexed
#  token                     :string(255)
#  amount                    :string(255)
#  card_number_last_4_digits :string(255)
#  plan                      :string(255)
#  last_update               :datetime
#  created_at                :datetime
#  updated_at                :datetime
#

require 'spec_helper'

describe SubscriptionTransaction do
  #columns
  should_have_column :token, :amount, :card_number_last_4_digits, :plan, :type => :string
  should_have_column :last_update, :type => :datetime
  
  #associations
  should_belong_to :account
end
