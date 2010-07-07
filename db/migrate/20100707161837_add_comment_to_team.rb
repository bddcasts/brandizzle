class AddCommentToTeam < ActiveRecord::Migration
  def self.up
    add_column :comments, :team_id, :integer
    add_index :comments, :team_id
    
    Comment.reset_column_information
    
    Comment.find_in_batches(:batch_size => 200) do |batch|
      batch.each do |c|
        c.update_attribute(:team_id, c.user.team_id)
      end
    end
    
  end

  def self.down
    remove_index :comments, :team_id
    remove_column :comments, :team_id
  end
end