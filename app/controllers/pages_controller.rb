class PagesController < ApplicationController
  skip_before_filter :require_valid_subscription
  
  def show
    if %w(about).include?(params[:id])
      render "pages/show/#{params[:id]}"
    else
      render :status => 404
    end
  end
end