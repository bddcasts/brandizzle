module FiltersHelper  
  def applied_filters(conditions={})
    conditions.delete_if {|k, v| v.blank? }
    return "You are viewing all results" if conditions.empty?
    
    s = "You are viewing "
    
    conditions.has_key?(:between_date) ? s << date_in_words(conditions[:between_date]) : s << ""
    s << " "
    
    if conditions.has_key?(:read_state) && !conditions.has_key?(:state_is)
      conditions[:read_state] == "0" ? s << "unread" : s << "read"
    else
      s << ""
    end
    s << " "

    conditions.has_key?(:state_is) ? s << conditions[:state_is] : s << ""
    s << " results "

    conditions.has_key?(:brand_id_is) ? s << "for brand #{Brand.find(conditions[:brand_id_is])}" : s << ""
    
    if conditions.has_key?(:read_state) && conditions[:read_state] == "0"
      s << " "
      s << link_to("Mark them as read", mark_all_as_read_brand_results_path(:search => (params[:search] || {}), :before => Time.now), :method => :post)
    end
    
    s
  end
  
  def brand_filter(label, brand_id=nil)
    url_options = merge_search_params(:brand_id_is => brand_id)
    
    link_to label,
      brand_results_path(url_options),
      :class => params[:search] && params[:search][:brand_id_is] == brand_id.to_s && "active" || nil
  end

  def state_filter(label, state=nil)
    url_options = merge_search_params(:state_is => state, :read_state => 1)
    
    link_to label,
      brand_results_path(url_options),
      :class => params[:search] && params[:search][:state_is] == state.to_s && params[:search][:read_state] == "1" && "active" || nil
  end

  def read_state_filter(label, state=nil)
    url_options = merge_search_params(:read_state => state, :state_is => nil)
    
    link_to label,
      brand_results_path(url_options),
      :class => params[:search] && params[:search][:read_state] == state.to_s && params[:search][:state_is].blank? && "active" || nil
  end
  
  def merge_search_params(options={})
    {:search => (params[:search] || {}).merge(options)}
  end
end