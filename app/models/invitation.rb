class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'

  validates_presence_of :recipient_email
  validates_format_of :recipient_email, :with => Authlogic::Regex.email
  validate :recipient_is_not_registered
  validate :sender_has_invitations, :if => :sender

  before_create :generate_token
  after_create :decrement_sender_count, :if => :sender

  def deliver_invitation!
    Notifier.deliver_invitation(self)
  end

  private
    def recipient_is_not_registered
      errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
    end

    def sender_has_invitations
      unless sender.invitation_limit > 0
        errors.add_to_base 'You have reached your limit of invitations to send.'
      end
    end

    def generate_token
      self.token = Authlogic::Random.friendly_token
    end

    def decrement_sender_count
      sender.decrement! :invitation_limit
    end
end
