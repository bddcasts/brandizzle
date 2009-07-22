class AddFollowUpToSearchResults < ActiveRecord::Migration
  def self.up
    add_column :search_results, :follow_up, :boolean
  end

  def self.down
    remove_column :search_results, :follow_up
  end
end
