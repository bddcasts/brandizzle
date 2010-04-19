class AddReadToBrandResult < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :read, :boolean, :default => false
    add_index :brand_results, :read
  end

  def self.down
    remove_index :brand_results, :read
    remove_column :brand_results, :read
  end
end
