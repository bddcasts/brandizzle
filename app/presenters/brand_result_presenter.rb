class BrandResultPresenter < Viewtastic::Base
  presents :brand_result
  
  delegate :id, :brand, :result, :follow_up?,
           :to => :brand_result

  delegate :current_user, :current_team,
           :to => :controller
  
  def action_links
    returning([]) do |links|
      links << link_to(truncate_url(brand_result.result.url), brand_result.result.url, :target => "_blank", :title => brand_result.result.url)
      links << link_to(brand_result.follow_up? ? 'Done' : 'Follow up', [:follow_up, brand_result], :method => :post)
    end
  end
  
  private
    def truncate_url(url)
      u = url.split('/')
      u.slice!(0,2)
      
      domain = u.delete_at(0)
      last = truncate(u.delete(u.last), :length => 35, :omission => "...")
      
      middle = u.length > 0 ? "/.../" : "/"
      
      "http://#{domain}#{middle}#{last}"
    end
end