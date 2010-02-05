class CreateResultsSearches < ActiveRecord::Migration
  def self.up
    create_table :results_searches, :id => false do |t|
      t.references :search
      t.references :result
    end
    
    add_index :results_searches, :search_id
    add_index :results_searches, :result_id
    add_index :results_searches, [:search_id, :result_id]
    
    remove_column :results, :search_id
  end

  def self.down
    add_column :results, :search_id, :integer
    
    remove_index :results_searches, [:search_id, :result_id]
    remove_index :results_searches, :result_id
    remove_index :results_searches, :search_id
    
    drop_table :results_searches
  end
end
