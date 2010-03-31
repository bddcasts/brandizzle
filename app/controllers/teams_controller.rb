class TeamsController < ApplicationController
  before_filter :require_user
  
  def index
    @team = current_team
  end
end