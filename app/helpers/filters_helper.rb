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

  def merge_search_params(options={})
    {:search => (params[:search] || {}).merge(options)}
  end
end