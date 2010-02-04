class Notifier < ActionMailer::Base
  default_url_options[:host] = "brandizzle.com"
  
  def activation_instructions(user)
    subject       "[Brandizzle.com] Activation Instructions"
    from          sender
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "[Brandizzle.com] Activation Complete"
    from          sender
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end
  
  private
    def sender
      "noreply@binarylogic.com"
    end
end
