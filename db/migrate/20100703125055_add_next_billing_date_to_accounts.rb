class AddNextBillingDateToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :next_billing_date, :date
    add_index :accounts, :next_billing_date
    Account.update_all("next_billing_date = '#{(1.month + 1.day).ago.to_s(:db)}'")
  end

  def self.down
    remove_column :accounts, :next_billing_date
  end
end
