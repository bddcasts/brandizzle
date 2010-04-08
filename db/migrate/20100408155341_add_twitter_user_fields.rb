class AddTwitterUserFields < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_uid, :string
    add_column :users, :name, :string
    add_column :users, :screen_name, :string
    add_column :users, :location, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :twitter_uid
    remove_column :users, :location
    remove_column :users, :screen_name
  end
end
