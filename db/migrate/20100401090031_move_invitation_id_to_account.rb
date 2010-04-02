class MoveInvitationIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :invitation_id, :string
    
    Account.reset_column_information
    
    User.all.each do |user|
      a = user.account
      a.invitation_id = user.invitation_id
      a.save(false)
    end
    
    remove_column :users, :invitation_id
  end

  def self.down
    add_column :users, :invitation_id, :string
    remove_column :accounts, :invitation_id
  end
end
