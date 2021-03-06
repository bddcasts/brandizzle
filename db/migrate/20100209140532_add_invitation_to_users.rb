class AddInvitationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_id, :string
    add_column :users, :invitation_limit, :integer, :default => 0
  end

  def self.down
    remove_column :users, :invitation_limit
    remove_column :users, :invitation_id
  end
end
