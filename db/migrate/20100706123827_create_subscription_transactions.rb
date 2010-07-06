class CreateSubscriptionTransactions < ActiveRecord::Migration
  def self.up
    create_table :subscription_transactions do |t|
      t.references :account
      t.string    "token"
      t.string    "amount"
      t.string    "card_number_last_4_digits"
      t.string    "plan"
      t.datetime  "last_update"
      
      t.timestamps
    end
    
    add_index :subscription_transactions, :account_id
  end

  def self.down
    remove_index :subscription_transactions, :account_id
    drop_table :subscription_transactions
  end
end