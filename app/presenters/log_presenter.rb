class LogPresenter < Viewtastic::Base
  presents :log => [:id, :loggable, :user, :loggable_type, :loggable_attributes, :created_at]
  
  delegate :current_user, :current_team,
          :to => :controller
  
  def dom_id
    log_dom_id
  end
  
  def log_type
    case loggable_type
    when "BrandResult"
      if !temperature.blank?
        content_tag("span", get_brand_result_temperature_label(temperature).capitalize, :class => "tag #{get_brand_result_temperature_label(temperature)}")
      else
        content_tag("span", get_brand_result_state_label(state).capitalize, :class => "tag #{state}")
      end
    when "Comment"
      content_tag("span", "Comment", :class => "tag comment")
    end
  end
  
  def description
    case loggable_type
    when "BrandResult"
      if !temperature.blank?
        brand_result_temperature_log_description(loggable, temperature)
      else
        brand_result_state_log_description(loggable, state)
      end
    when "Comment"
      comment_log_description(loggable)
    end
  end
  
  def brand_result_state_log_description(brand_result, state)
    message = [
      user,
      action_description,
      subject_description,
      "as",
      get_brand_result_state_label(state)
    ]
    
    message.map(&:to_s).join(' ')
  end
  
  def brand_result_temperature_log_description(brand_result, temperature)    
    message = [
      user,
      action_description,
      subject_description,
      "as",
      get_brand_result_temperature_label(temperature)
    ]
    
    message.map(&:to_s).join(' ')
  end
  
  def comment_log_description(comment)
    message = [
      user,
      action_description,
      "on",
      subject_description
    ]
    
    message.map(&:to_s).join(' ')
  end
  
  def action_description
    if comment?
      if loggable.nil?
        "commented"
      else
        link_to("commented", brand_result_path(loggable.brand_result, :anchor => "comment_#{loggable.id}"))
      end
    else
      "marked"
    end
  end
  
  def subject_description
    description = h(truncate(loggable_attributes["body"] || "a result"))
    
    if loggable.nil?
      description
    else
      link_to(description, comment? ? loggable.brand_result : loggable)
    end
  end
  
  def comment?
    loggable_type == "Comment"
  end
  
  def result?
    loggable_type == "BrandResult"
  end
  
  def get_brand_result_state_label(state)
    case state
    when "follow_up" then "follow up"
    when "normal" then "rejected"
    when "done" then "done"
    end
  end
  
  def get_brand_result_temperature_label(temperature)
    case temperature.to_i
    when -1 then "negative"
    when 1 then "positive"
    when 0 then "neutral"
    end
  end
  
  def state
    loggable_attributes['state']
  end
  
  def temperature
    loggable_attributes['temperature']
  end
end