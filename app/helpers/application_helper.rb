module ApplicationHelper
  include Formtastic::SemanticFormHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def title_tag
    common_title = 'TalentRockr'
    content_tag(:title, @content_for_title.blank? && "Untitled | #{common_title}" || "#{@content_for_title} | #{common_title}")
  end
  
  def show_title?
    @show_title
  end
  
  def active(s)
    case s
    when s = "results"
      controller.controller_name == "brand_results" && (params[:search].blank? || params[:search][:follow_up_is] != "true")
    when s = "follow_up"
      controller.controller_name == 'brand_results' && params[:search] && params[:search][:follow_up_is] == "true"
    when s = "brands"
      controller.controller_name == "brands"
    when s = "account"
      controller.controller_name == "accounts"
    when s = "team"
      controller.controller_name == "teams" || controller.controller_name == "users"
    when s = "invitation"
      controller.controller_name == "invitations"
    end
  end
  
  def brand_filter(label, brand_id=nil)
    url_options = {:search => (params[:search] || {}).merge({:brand_id_is => brand_id})}
    
    link_to label, brand_results_path(url_options), :class => params[:search] && params[:search][:brand_id_is] == brand_id.to_s && "active" || nil
  end

  def time_filter(search, options={}, html_options={})
    before_scope ||= "#{options[:by]}_before"
    after_scope ||= "#{options[:by]}_after"
    
    after = options[:between].blank? ? Time.utc(1970, 1, 1).to_s(:db) : options[:between].first.to_time.to_s(:db)
    before = options[:between].blank? ? Time.now.end_of_day.to_s(:db) : options[:between].last.to_time.to_s(:db)
    
    scope = { before_scope => before, after_scope => after }
    
    time_conditions = search.conditions.values.map{ |v| v.acts_like?(:time) && v.to_s(:db)}
    selected = time_conditions.include?(before) && time_conditions.include?(after)
        
    if selected
      html_options[:class] = "active"
    end
    
    url_options = {
      :search => (params[:search] || {}).merge(scope)
    }
    
    link_to options[:as], url_for(url_options), html_options
  end  
end
