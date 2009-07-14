class AddLatestIdToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :latest_id, :string
  end

  def self.down
    remove_column :searches, :latest_id
  end
end
