class CreateBrandQueries < ActiveRecord::Migration
  def self.up
    create_table :brand_queries do |t|
      t.references :brand
      t.references :query
    end
    
    add_index :brand_queries, :brand_id
    add_index :brand_queries, :query_id
    add_index :brand_queries, [:brand_id, :query_id]
  end

  def self.down
    remove_index :brand_queries, [:brand_id, :query_id]
    remove_index :brand_queries, :query_id
    remove_index :brand_queries, :brand_id
    
    drop_table :brand_queries
  end
end
