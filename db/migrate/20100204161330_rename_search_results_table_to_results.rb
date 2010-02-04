class RenameSearchResultsTableToResults < ActiveRecord::Migration
  def self.up
    remove_index :search_results, :column => :url
    remove_index :search_results, :search_id
    rename_table :search_results, :results
    
    add_index :results, :url, :unique => true
  end

  def self.down
    remove_index :results, :url
    
    rename_table :results, :search_results
    add_index :search_results, :search_id
    add_index :search_results, :url, :unique => true
  end
end
