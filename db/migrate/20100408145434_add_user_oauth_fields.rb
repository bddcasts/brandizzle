class AddUserOauthFields < ActiveRecord::Migration
  def self.up
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_secret, :string
    
    add_index :users, :oauth_token
  end

  def self.down
    remove_index :users, :oauth_token
    
    remove_column :users, :oauth_token
    remove_column :users, :oauth_secret
  end
end
