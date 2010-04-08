module FiltersHelper  
  def brand_filter(label, brand_id=nil)
    url_options = merge_search_params(:brand_id_is => brand_id)
    
    link_to label,
      brand_results_path(url_options),
      :class => params[:search] && params[:search][:brand_id_is] == brand_id.to_s && "active" || nil
  end

  def state_filter(label, state=nil)
    url_options = merge_search_params(:state_is => state)
    
    link_to label,
      brand_results_path(url_options),
      :class => params[:search] && params[:search][:state_is] == state.to_s && "active" || nil
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
  
  def merge_search_params(options={})
    {:search => (params[:search] || {}).merge(options)}
  end
end