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
#  invitation_limit  :integer(4)
#  team_id           :integer(4)
#

class User < ActiveRecord::Base
  # acts_as_authentic
  
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = { :on => :update, :minimum => 4, :if => :has_no_credentials? }
    c.validates_length_of_password_confirmation_field_options = { :on => :update, :minimum => 4, :if => :has_no_credentials? }
  end
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  has_one :account
  belongs_to :team
  
  before_create :set_invitation_limit
    
  attr_accessible :login, :email, :password, :password_confirmation, :active
    
  def to_s
    login
  end
  
  def toggle_active
    toggle!(:active)
  end
  
  def account_holder?
    !account.blank?
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def deliver_user_invitation!
    reset_perishable_token!
    Notifier.deliver_user_invitation(self)
  end

  private
    def set_invitation_limit
      self.invitation_limit = Settings.invitations.limit
    end
    
    def has_no_credentials?
      self.crypted_password.blank?
    end
end

