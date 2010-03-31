class BrandResultPresenter < Viewtastic::Base
  presents :brand_result
  
  delegate :id, :brand, :result, :follow_up?,
           :to => :brand_result

  delegate :current_user, :current_team,
         :to => :controller
  
  def action_links
    returning([]) do |links|
      links << link_to(brand_result.result.url, brand_result.result.url, :target => "_blank")
      links << link_to(brand_result.follow_up? ? 'Done' : 'Follow up', [:follow_up, brand_result], :method => :post)
    end
  end
end