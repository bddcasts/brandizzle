class DashboardController < ApplicationController
  before_filter :require_user
  
  def index
    @logs = current_team.logs.paginate(:include => :user, :page => params[:page], :order => "created_at DESC")
  end
end