class BrandResultPresenter < Viewtastic::Base
  include LinksHelper
  
  presents :brand_result => [:id, :brand, :result, :comments, :comments_count, :temperature, :read, :positive?, :negative?, :neutral?, :follow_up?, :read?]

  delegate :current_user, :current_team,
           :to => :controller
  
  def dom_id
   brand_result_dom_id
  end

  def state_links
    returning([]) do |links|
      case brand_result.state
      when "normal"
        links << link_to_remote_update('Follow up', follow_up_brand_result_path(brand_result))
      when "follow_up"
        links << link_to_remote_update('Done', finish_brand_result_path(brand_result))
        links << link_to_remote_update('Reject', reject_brand_result_path(brand_result))
      end
      links << link_to_remote_update("Mark as read", mark_as_read_brand_result_path(brand_result)) unless brand_result.read?
      links << link_to("Reply", twitter_reply_url, :target => "_blank") if current_user.using_twitter? && result.twitter?
    end
  end
  
  def temperature_links
    returning([]) do |links|
      brand_result.positive? ? links << content_tag("span", "+", :class => "strong positive") : links << link_to_remote_update("+", positive_brand_result_path(brand_result))
      brand_result.neutral? ? links << content_tag("span", "=", :class => "strong neutral") : links << link_to_remote_update("=", neutral_brand_result_path(brand_result))
      brand_result.negative? ? links << content_tag("span", "-", :class => "strong negative") : links << link_to_remote_update("-", negative_brand_result_path(brand_result))
    end
  end
  
  def view_links
    returning([]) do |links|
      links << link_to("View", brand_result_path(brand_result))
      links << link_to(pluralize(comments_count, "comment"), brand_result_path(brand_result, :anchor => "comments"))
      links << result_link
    end
  end
  
  def result_link
    link_to(truncate_url(brand_result.result), brand_result.result.url, :target => "_blank", :title => brand_result.result.url)
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
  
  def twitter_reply_url
    returning("") do |s|
      s << "http://twitter.com/"
      s << "?status=@"
      s << result.url.split("/")[3]
      s << "&in_reply_to_status_id="
      s << result.url.split("/").last
      s << "&in_reply_to="
      s << result.url.split("/")[3]
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
