class AddBrandsCountToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :brands_count, :integer, :default => 0
  end

  def self.down
    remove_column :teams, :brands
  end
end
