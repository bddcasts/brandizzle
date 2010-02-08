class CreateBrandResults < ActiveRecord::Migration
  def self.up
    create_table :brand_results do |t|
      t.references :brand
      t.references :result
      t.timestamps
    end
    
    add_index :brand_results, :brand_id
    add_index :brand_results, :result_id
    add_index :brand_results, [:brand_id, :result_id]
  end

  def self.down
    remove_index :brand_results, [:brand_id, :result_id]
    remove_index :brand_results, :result_id
    remove_index :brand_results, :brand_id
    drop_table :brand_results
  end
end
