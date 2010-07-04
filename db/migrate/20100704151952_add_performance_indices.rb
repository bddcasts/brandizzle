class AddPerformanceIndices < ActiveRecord::Migration
  def self.up
    add_index :brands, :team_id
    add_index :results, :created_at
  end

  def self.down
    remove_index :results, :created_at
    remove_index :brands, :team_id
  end
end
