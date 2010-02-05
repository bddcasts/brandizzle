class AddUserToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :user_id, :integer
  end

  def self.down
    remove_column :brands, :user_id
  end
end
