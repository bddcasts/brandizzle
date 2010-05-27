class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :plan_id
      t.integer :account_id
      t.integer :subscription_id
      t.string :card_token
      t.string :customer_id
      t.string :status

      t.timestamps
    end
    
    add_index :subscriptions, :account_id
  end

  def self.down
    drop_table :subscriptions
  end
end
