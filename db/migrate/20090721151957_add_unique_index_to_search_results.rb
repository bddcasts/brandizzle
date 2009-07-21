class AddUniqueIndexToSearchResults < ActiveRecord::Migration
  def self.up
    add_index :search_results, :url, :unique => true
  end

  def self.down
    remove_index :search_results, :column => :url
  end
end
