# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(255)     not null
#  email             :string(255)     not null, indexed
#  crypted_password  :string(255)     not null
#  password_salt     :string(255)     not null
#  persistence_token :string(255)     not null
#  perishable_token  :string(255)     not null, indexed
#  active            :boolean(1)      default(TRUE), not null
#  created_at        :datetime
#  updated_at        :datetime
#  invitation_id     :string(255)
#  invitation_limit  :integer(4)
#  team_id           :integer(4)
#

class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :invitation_id, :message => 'Invitation is required', :if => :account_holder?
  validates_uniqueness_of :invitation_id, :message => 'Invitation has already been used', :if => :account_holder?
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  has_one :account
  belongs_to :team, :counter_cache => true
  
  before_create :set_invitation_limit
    
  attr_accessible :login, :email, :password, :password_confirmation, :active, :invitation_token
    
  def to_s
    login
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  def account_holder?
    !account.blank?
  end

  private
    def set_invitation_limit
      self.invitation_limit = Settings.invitations.limit
    end
end

