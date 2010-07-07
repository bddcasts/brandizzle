class DashboardController < ApplicationController
  before_filter :require_user
  
  def index
    @logs = current_team.logs.paginate(:include => :user, :page => params[:page], :order => "created_at DESC")
    @follow_up_brand_results = current_team.brand_results.latest_follow_up
    @latest_comments = current_team.comments.latest
  end
end