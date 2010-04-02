class CreateTeam < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.references :account
      t.timestamps
    end
    
    Account.all.each do |account|
      t = Team.new(:account => account)
      t.save(false)
    end
  end

  def self.down
    drop_table :teams
  end
end
