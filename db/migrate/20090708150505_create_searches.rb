class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.references :brand
      t.string :term
      t.timestamps
    end
    
    add_index :searches, :brand_id
  end

  def self.down
    remove_index :searches, :brand_id
    drop_table :searches
  end
end
