class DashboardController < ApplicationController
  before_filter :require_user
  
  def index
    @logs = current_team.logs.paginate(:include => [:user, :loggable], :page => params[:page], :order => "created_at DESC")
    @latest_follow_up_brand_results = current_team.brand_results.latest_follow_up
    @follow_up_brand_results_count = current_team.brand_results.follow_up.count
    @latest_comments = current_team.comments.latest
  end
end