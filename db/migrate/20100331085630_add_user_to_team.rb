class AddUserToTeam < ActiveRecord::Migration
  def self.up
    add_column :users, :team_id, :integer
    
    User.all.each do |user|
      user.team = user.account.team
      user.save(false)
    end
  end

  def self.down
    remove_column :users, :team_id
  end
end
