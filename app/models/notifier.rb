class Notifier < ActionMailer::Base  
  def password_reset_instructions(user)
    subject       "[Brandizzle.com] Password Reset Instructions"
    from          sender
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def invitation(invitation)
    subject       "[Brandizzle.com] Invitation to our private beta"
    from          sender
    recipients    invitation.recipient_email
    sent_on       Time.now
    body          :signup_url => signup_url(invitation.token)
  end
  
  def user_invitation(user)
    subject       "[Brandizzle.com] #{user.team.account.holder} has invited you to join Brandizzle"
    from          user.team.account.holder
    recipients    user.email
    sent_on       Time.now
    body          :signup_url => edit_user_signup_url(user.perishable_token)
  end
  
  private
    def sender
      "noreply@brandizzle.com"
    end
end