class AddOriginalAttributesToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :loggable_attributes, :text
    remove_column :logs, :body
  end

  def self.down
    remove_column :logs, :loggable_attributes
    add_column :logs, :body, :text
  end
end
