class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :login_count, :integer, :null => false, :default => 0
    add_column :users, :last_request_at, :datetime
  end

  def self.down
    remove_column :users, :last_request_at
    remove_column :users, :login_count
  end
end