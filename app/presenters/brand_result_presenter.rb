class BrandResultPresenter < Viewtastic::Base
  include LinksHelper
  
  presents :brand_result => [:id, :brand, :result, :comments, :comments_count, :temperature, :positive?, :negative?, :neutral?, :follow_up?]

  delegate :current_user, :current_team,
           :to => :controller
  
  def dom_id
   brand_result_dom_id
  end
  
  def action_links
    returning([]) do |links|
      links << link_to(truncate_url(brand_result.result), brand_result.result.url, :target => "_blank", :title => brand_result.result.url)
      links << link_to("View", brand_result_path(brand_result))
      case brand_result.state
      when "normal"
        links << link_to_remote_update('Follow up', follow_up_brand_result_path(brand_result))
      when "follow_up"
        links << link_to_remote_update('Done', finish_brand_result_path(brand_result))
        links << link_to_remote_update('Reject', reject_brand_result_path(brand_result))
      end
    end
  end
  
  def temperature_links
    returning([]) do |links|      
      brand_result.positive? ? links << content_tag("span", "+", :class => "strong positive") : links << link_to_remote_update("+", positive_brand_result_path(brand_result))
      brand_result.neutral? ? links << content_tag("span", "=", :class => "strong neutral") : links << link_to_remote_update("=", neutral_brand_result_path(brand_result))
      brand_result.negative? ? links << content_tag("span", "-", :class => "strong negative") : links << link_to_remote_update("-", negative_brand_result_path(brand_result))
    end
  end
  
  def status
    case brand_result.state
    when "normal"
      ""
    when "follow_up"
      content_tag("span", "follow up", :class => "tag follow_up")
    when "done"
      content_tag("span", "done", :class => "tag done")
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
