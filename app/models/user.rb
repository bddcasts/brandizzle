class User < ActiveRecord::Base
  acts_as_authentic
  
  attr_accessible :login, :email, :password, :password_confirmation

  def active?
    active
  end
  
  def activate!
    self.active = true
    save
  end
  
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
end
