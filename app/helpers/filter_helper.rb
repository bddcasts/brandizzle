module FilterHelper
  def time_filter(filter=nil)
    now = Time.now.to_date
    
    time_filter_params = case filter
    when "today"
      { :result_created_at_gte => now,
        :result_created_at_lte => now.tomorrow}
    when "yesterday"
      { :result_created_at_gte => now.yesterday,
        :result_created_at_lte => now}
    when "this week"
      { :result_created_at_gte => now.beginning_of_week,
        :result_created_at_lte => now.tomorrow}
    when "last week"
      { :result_created_at_gte => (now -7).beginning_of_week,
        :result_created_at_lte => (now - 7).end_of_week.midnight}
    when "this month"
      { :result_created_at_gte => now.beginning_of_month,
        :result_created_at_lte => now.tomorrow}
    when "last month"
      { :result_created_at_gte => now.last_month.beginning_of_month,
        :result_created_at_lte => now.last_month.end_of_month}
    else
      { :result_created_at_gte => nil,
        :result_created_at_lte => nil}
    end
    merge_search_params(time_filter_params)
  end
  
  def merge_search_params(options={})
    {:search => (params[:search] || {}).merge(options)}
  end
end