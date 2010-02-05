class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.references :user
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
