class ChangeUserActiveColumn < ActiveRecord::Migration
  def self.up
    change_column :users, :active, :boolean, :null => false, :default => false
  end

  def self.down
    change_column :users, :active, :boolean
  end
end
