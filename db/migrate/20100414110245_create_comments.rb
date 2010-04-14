class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :brand_result
      t.references :user
      t.text :content
      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :brand_result_id
  end

  def self.down
    remove_index :comments, :brand_result_id
    remove_index :comments, :user_id
    drop_table :comments
  end
end
