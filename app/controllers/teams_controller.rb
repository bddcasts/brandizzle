class TeamsController < ApplicationController
  before_filter :require_user
  
  def show
    @team = current_team
  end
end