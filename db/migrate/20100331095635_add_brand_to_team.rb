class AddBrandToTeam < ActiveRecord::Migration
  def self.up
    add_column :brands, :team_id, :integer
    remove_column :brands, :user_id
  end

  def self.down
    add_column :brands, :user_id, :integer
    remove_column :brands, :team_id
  end
end
