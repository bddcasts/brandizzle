class AddConnotationToBrandResult < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :connotation, :integer, :default => 0
    add_index :brand_results, :connotation
  end

  def self.down
    remove_index :brand_results, :connotation
    remove_column :brand_results, :connotation
  end
end
