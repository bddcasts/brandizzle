class SearchesController < ApplicationController
  before_filter :find_brand
  
  def create
    @search = @brand.searches.build(params[:search])
    if @search.save
      flash[:notice] = "Added search term."
    else
      flash[:error] = "Search term not added."
    end
    redirect_to edit_brand_path(@brand)
  end
  
  def destroy
    @search = @brand.searches.find(params[:id])
    @search.destroy
    flash[:notice] = "Deleted search term."
    redirect_to edit_brand_path(@brand)    
  end
  
  private
    def find_brand
      @brand = Brand.find(params[:brand_id])
    end
end