class CreateUserDetails < ActiveRecord::Migration
  def self.up
    create_table :user_details do |t|
      t.references :user
      t.string :twitter_screen_name
      t.string :twitter_location
      t.boolean :email_updates, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_details
  end
end
