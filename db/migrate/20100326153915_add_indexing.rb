class AddIndexing < ActiveRecord::Migration
  def self.up
    add_index :users, :perishable_token  
    add_index :users, :email
  end

  def self.down
  end
end
