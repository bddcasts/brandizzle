class AddTemperatureToBrandResult < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :temperature, :integer, :default => nil
    add_index :brand_results, :temperature
  end

  def self.down
    remove_index :brand_results, :temperature
    remove_column :brand_results, :temperature
  end
end
