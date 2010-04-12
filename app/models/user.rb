# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(255)     not null
#  email             :string(255)     not null, indexed
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)     not null
#  perishable_token  :string(255)     not null, indexed
#  active            :boolean(1)      default(TRUE), not null
#  created_at        :datetime
#  updated_at        :datetime
#  invitation_limit  :integer(4)      default(0)
#  team_id           :integer(4)
#  oauth_token       :string(255)     indexed
#  oauth_secret      :string(255)
#  twitter_uid       :string(255)
#  name              :string(255)
#  screen_name       :string(255)
#  location          :string(255)
#  avatar_url        :string(255)
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = { :on => :update, :minimum => 4, :if => :has_no_credentials? }
    c.validates_length_of_password_confirmation_field_options = { :on => :update, :minimum => 4, :if => :has_no_credentials? }
  end
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  has_one :account
  belongs_to :team
  
  before_create :set_invitation_limit
  before_save :populate_oauth_user
    
  attr_accessible :name, :login, :email, :password, :password_confirmation, :active
  
  validates_presence_of :email, :on => :create
  validates_format_of :email, :with => Authlogic::Regex.email
    
  def to_s
    name.blank? && login || name
  end
  
  def toggle_active
    toggle!(:active)
  end
  
  def account_holder?
    !account.blank?
  end
  
  def using_twitter?
    !!oauth_token
  end

  def has_no_credentials?
    self.crypted_password.blank? && !using_twitter?
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

    def populate_oauth_user
      return unless twitter_uid.blank?

      if using_twitter?
        @response = UserSession.oauth_consumer.request(:get, '/account/verify_credentials.json',
        access_token, { :scheme => :query_string })
        if @response.is_a?(Net::HTTPSuccess)
          user_info = JSON.parse(@response.body)

          self.name        = user_info['name']
          self.twitter_uid = user_info['id']
          self.screen_name = user_info['screen_name']
          self.location    = user_info['location']
          self.avatar_url  = user_info['profile_image_url']
        end
      end
    end    
end

