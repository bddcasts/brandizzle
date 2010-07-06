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

class SubscriptionTransaction < ActiveRecord::Base
  belongs_to :account
end
