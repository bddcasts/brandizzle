class BrandResultPresenter < Viewtastic::Base
  presents :brand_result
  
  delegate :id, :brand, :result, :follow_up?,
           :to => :brand_result

  delegate :current_user, :current_team,
           :to => :controller
  
  def dom_id
   brand_result_dom_id
  end
  
  def action_links
    returning([]) do |links|
      links << link_to(truncate_url(brand_result.result), brand_result.result.url, :target => "_blank", :title => brand_result.result.url)
      case brand_result.state
      when "normal"
        links << link_to('Follow up', brand_result_path(brand_result, :action_type => "follow_up"), :method => :put)
      when "follow_up"
        links << link_to('Done', brand_result_path(brand_result, :action_type => "finish"), :method => :put)
        links << link_to('Reject', brand_result_path(brand_result, :action_type => "reject"), :method => :put)
      end
    end
  end
  
  def status
    case brand_result.state
    when "normal"
      ""
    when "follow_up"
      content_tag("span", "follow up", :class => "follow_up")
    when "done"
      content_tag("span", "done", :class => "done")
    end
  end
  
  private
    def truncate_url(result)
      if result.source == "twitter"
        result.url
      else
        u = result.url.split('/')
        u.slice!(0,2)
      
        domain = u.delete_at(0)
        last = truncate(u.delete(u.last), :length => 35, :omission => "...")
      
        middle = u.length > 0 ? "/.../" : "/"
      
        "http://#{domain}#{middle}#{last}"
      end
    end
end