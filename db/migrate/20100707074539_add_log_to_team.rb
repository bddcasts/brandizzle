class AddLogToTeam < ActiveRecord::Migration
  def self.up
    add_column :logs, :team_id, :integer
    add_index :logs, :team_id
    
    Log.reset_column_information
    
    Log.find_in_batches(:batch_size => 200) do |batch|
      batch.each do |l|
        l.update_attribute(:team_id, l.user.team_id)
      end
    end
  end

  def self.down
    remove_index :logs, :team_id
    remove_column :logs, :team_id
  end
end