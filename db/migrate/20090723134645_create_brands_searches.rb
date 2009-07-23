class CreateBrandsSearches < ActiveRecord::Migration
  def self.up
    create_table :brands_searches, :id => false do |t|
      t.references :brand
      t.references :search
    end
    add_index :brands_searches, :brand_id
    add_index :brands_searches, :search_id
    add_index :brands_searches, [:brand_id, :search_id]
    
    remove_column :searches, :brand_id
  end

  def self.down
    add_column :searches, :brand_id, :integer

    remove_index :brands_searches, [:brand_id, :search_id]
    remove_index :brands_searches, :search_id
    remove_index :brands_searches, :brand_id
    drop_table :brands_searches
  end
end
