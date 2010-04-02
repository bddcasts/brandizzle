class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
