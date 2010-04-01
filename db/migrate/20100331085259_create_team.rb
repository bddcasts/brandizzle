class CreateTeam < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.references :account
      t.timestamps
    end
    
    Account.all.each do |account|
      Team.create(:account => account)
    end
  end

  def self.down
    drop_table :teams
  end
end
