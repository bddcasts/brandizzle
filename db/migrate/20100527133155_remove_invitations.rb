class RemoveInvitations < ActiveRecord::Migration
  def self.up
    drop_table :invitations
    remove_column :accounts, :invitation_id
    remove_column :users, :invitation_limit
  end

  def self.down
    add_column :users, :invitation_limit, :integer,  :default => 0
    add_column :accounts, :invitation_id, :string
    create_table "invitations", :force => true do |t|
      t.integer  "sender_id"
      t.string   "recipient_email"
      t.string   "token"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
