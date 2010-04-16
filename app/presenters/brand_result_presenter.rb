class BrandResultPresenter < Viewtastic::Base
  include LinksHelper
  
  presents :brand_result => [:id, :brand, :result, :follow_up?, :comments, :comments_count, :connotation]

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
        links << link_to_remote_update('Follow up', brand_result_path(brand_result, :action_type => "follow_up"))
      when "follow_up"
        links << link_to_remote_update('Done', brand_result_path(brand_result, :action_type => "finish"))
        links << link_to_remote_update('Reject', brand_result_path(brand_result, :action_type => "reject"))
      end
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
  
  def connotation_links
    returning([]) do |links|
      if connotation == 0
        links << link_to_remote_update("+", brand_result_path(brand_result, :action_type => "positive"), :class => "positive")
        links << link_to_remote_update("-", brand_result_path(brand_result, :action_type => "negative"), :class => "negative")
      else
        links << content_tag("span", connotation_in_words, :class => "tag #{connotation_in_words.downcase}")
      end
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
    
    def connotation_in_words
      case connotation
      when -1 then "Negative"
      when 1 then "Positive"
      else "Neutral"
      end
    end
end