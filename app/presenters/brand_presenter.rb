class BrandPresenter < Viewtastic::Base
  presents :brand => [:id, :name, :queries]
  
  delegate :current_user, :current_team,
           :to => :controller

  def dom_id
    brand_dom_id
  end
    
  def action_links
    returning([]) do |links|
      if current_user.account_holder?
        links << link_to("Manage", edit_brand_path(brand))
        links << link_to("Remove", brand_path(brand), :method => :delete, :class => "delete", :confirm => "Are you sure you want to remove #{brand}?")
      end
    end
  end
end