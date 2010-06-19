class AddCompToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :comp, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :comp
  end
end
