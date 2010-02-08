class BrandResultsController < ApplicationController
  before_filter :require_user
  before_filter :find_result
  
  def index
    @brands = current_user.brands

    @search = BrandResult.search((params[:search] || {}).merge(:brand_user_id_is => current_user.id))
    
    @brand_results = @search.paginate(
      :page => params[:page],
      :per_page => 15,
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