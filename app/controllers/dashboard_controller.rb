class DashboardController < ApplicationController
  before_filter :require_user
  
  def index
    @logs = current_team.logs.all(:order => "created_at DESC")
  end
end