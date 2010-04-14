class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.references :loggable, :polymorphic => true
      t.references :user
      t.text :body
      t.timestamps
    end
    
    add_index :logs, [:loggable_id, :loggable_type]
  end

  def self.down
    drop_table :logs
  end
  
end
