class CreateTeam < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.references :account
      t.integer :users_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
