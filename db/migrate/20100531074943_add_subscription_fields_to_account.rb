class AddSubscriptionFieldsToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :plan_id, :string
    add_column :accounts, :customer_id, :string
    add_column :accounts, :card_token, :string
    add_column :accounts, :subscription_id, :string
    add_column :accounts, :status, :string
    add_column :accounts, :card_type, :string
    add_column :accounts, :card_number_last_4_digits, :string
  end

  def self.down
    remove_column :accounts, :card_number_last_4_digits
    remove_column :accounts, :card_type
    remove_column :accounts, :status
    remove_column :accounts, :subscription_id
    remove_column :accounts, :card_token
    remove_column :accounts, :customer_id
    remove_column :accounts, :plan_id
  end
end