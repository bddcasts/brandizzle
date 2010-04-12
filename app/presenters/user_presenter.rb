class UserPresenter < Viewtastic::Base
  presents :user
  
  delegate :id, :login, :email, :avatar_url, :active?, :has_no_credentials?, :using_twitter?,
           :to => :user
           
  delegate :current_user, :current_team,
          :to => :controller
  
  def dom_id
    user_dom_id
  end
  
  def action_links
    returning([]) do |links|
      if current_user.account_holder?
        links << link_to("Remove", team_user_path(user), :method => :delete, :class => "delete", :confirm => "Are you sure you want to remove #{user}?")
        links << link_to(user.active? ? 'Disable' : 'Enable', [:alter_status, :team, user], :method => :post, :class => user.active? && "delete")
      end
    end    
  end
  
  def avatar
    if using_twitter?
      avatar_url
    else    
      gravatar_url(email)
    end
  end
  
  def status
    if user.has_no_credentials?
      "pending"
    elsif user.active?
      ""
    else
      "disabled"
    end
  end
  
  private
    def gravatar_url(email)
      "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&size=48"
    end
end