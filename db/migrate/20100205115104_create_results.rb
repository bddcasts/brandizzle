class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.text    :body
      t.string  :source
      t.string  :url
      t.boolean :follow_up
      t.timestamps
    end
    
    add_index :results, :url, :unique => true
  end

  def self.down
    remove_index :results, :column => :url
    drop_table :results
  end
end
