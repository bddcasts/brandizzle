class CreateQueriesResults < ActiveRecord::Migration
  def self.up
    create_table :search_results do |t|
      t.references :query
      t.references :result
    end
    
    add_index :search_results, :query_id
    add_index :search_results, :result_id
    add_index :search_results, [:query_id, :result_id]
  end

  def self.down
    remove_index :search_results, [:query_id, :result_id]
    remove_index :search_results, :result_id
    remove_index :search_results, :query_id
    drop_table :search_results
  end
end
