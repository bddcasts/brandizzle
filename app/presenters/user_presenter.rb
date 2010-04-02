class UserPresenter < Viewtastic::Base
  presents :user
  
  delegate :id, :login, :email, :active?,
           :to => :user
           
  delegate :current_user, :current_team,
          :to => :controller
  
  def dom_id
    user_dom_id
  end
  
  def action_links
    returning([]) do |links|
      if current_user.account_holder?
        links << link_to("Edit", edit_user_path(user))
        links << link_to("Remove", user_path(user), :method => :delete, :class => "remove", :confirm => "Are you sure you want to remove #{user}?")
        links << link_to(user.active? ? 'Disable' : 'Enable', [:alter_status, user], :method => :post)
      end
    end    
  end
end