# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(255)     not null
#  email             :string(255)     not null
#  crypted_password  :string(255)     not null
#  password_salt     :string(255)     not null
#  persistence_token :string(255)     not null
#  perishable_token  :string(255)     not null
#  active            :boolean(1)      default(FALSE), not null
#  created_at        :datetime
#  updated_at        :datetime
#  invitation_id     :string(255)
#  invitation_limit  :integer(4)      default(0)
#

class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :invitation_id, :message => 'Invitation is required', :if => :account_holder?
  validates_uniqueness_of :invitation_id, :message => 'Invitation has already been used', :if => :account_holder?
  
  has_many :brands
  has_many :brand_results, :through => :brands
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  has_one :account
  
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
