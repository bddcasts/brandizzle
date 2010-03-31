class BrandResultsController < ApplicationController
  before_filter :require_user
  before_filter :find_result
  helper :filter
  
  def index
    @brands = current_team.brands
    @search = current_team.brand_results.search(params[:search] || {})
    
    @brand_results = @search.paginate(
      :page => params[:page],
      :include => [:result],
      :order => "results.created_at DESC")
  end
  
  def follow_up
    @brand_result.toggle_follow_up    
    redirect_to request.referer || brands_path
  end

  private
    def find_result
      @brand_result = BrandResult.find(params[:id]) if params[:id]
    end
end