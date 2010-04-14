class LogPresenter < Viewtastic::Base
  presents :log
  
  delegate :id, :loggable, :user, :loggable_type, :loggable_attributes, :created_at,
           :to => :log
           
  delegate :current_user, :current_team,
          :to => :controller
  
  def dom_id
    log_dom_id
  end
  
  def log_type
    case loggable_type
    when "BrandResult"
      content_tag("span", "Result", :class => "tag #{loggable_attributes['state']}")
    when "Comment"
      content_tag("span", "Comment", :class => "tag comment")
    end
  end
  
  def description
    case loggable_type
    when "BrandResult"
      brand_result_log_description(loggable, loggable_attributes["state"])
    when "Comment"
      comment_log_description(loggable)
    end
  end
  
  def brand_result_log_description(brand_result, state)
    returning("") do |s|
      s << user.to_s
      s << " marked "
      s << link_to("a result", polymorphic_path(brand_result))
      s << " as "
      s << state.gsub("_", " ")
    end
  end
  
  def comment_log_description(comment)
    returning("") do |s|
      s << user.to_s
      s << " "
      s << link_to("commented", brand_result_path(comment.brand_result, :anchor => "comment_#{comment.id}"))
      s << " on "
      s << link_to("a result", brand_result_path(comment.brand_result))
    end
  end
end