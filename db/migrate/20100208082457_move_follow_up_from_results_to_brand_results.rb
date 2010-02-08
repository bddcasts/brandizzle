class MoveFollowUpFromResultsToBrandResults < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :follow_up, :boolean, :default => false
    remove_column :results, :follow_up
  end

  def self.down
    add_column :results, :follow_up, :boolean
    remove_column :brand_results, :follow_up
  end
end
