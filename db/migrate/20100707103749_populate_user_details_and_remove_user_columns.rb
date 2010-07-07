class PopulateUserDetailsAndRemoveUserColumns < ActiveRecord::Migration
  def self.up
    User.all.each do |u|
      u.create_user_detail(:twitter_location => u.location, :twitter_screen_name => u.screen_name)
    end
    
    remove_column :users, :screen_name
    remove_column :users, :location
  end

  def self.down
    add_column :users, :location, :string
    add_column :users, :screen_name, :string
  end
end
