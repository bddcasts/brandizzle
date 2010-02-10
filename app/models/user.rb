class User < ActiveRecord::Base
  acts_as_authentic
  has_many :brands
  
  attr_accessible :login, :email, :password, :password_confirmation, :invitation_token #invitation_token only with invations
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id' #with invitations
  belongs_to :invitation #with invitations
  
  before_create :set_invitation_limit #with invitations
  before_save :activate #with invitations
  
  validates_presence_of :invitation_id, :message => 'Invitation is required' #with invitations
  validates_uniqueness_of :invitation_id, :message => 'Invitation has already been used' #with invitations

  #without invitations
  # def active?
  #   active
  # end
  
  #without invitations
  # def activate!
  #   self.active = true
  #   save
  # end
    
  def to_s
    login
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  #with invitations
  def invitation_token
    invitation.token if invitation
  end

  #with invitations
  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  private
    #with invitations
    def set_invitation_limit
      self.invitation_limit = Settings.invitations.limit
    end
    
    #with invitations
    def activate
      self.active = true
    end
end
