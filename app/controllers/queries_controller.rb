class QueriesController < ApplicationController
  before_filter :require_user
  before_filter :require_account_holder
  before_filter :check_search_terms_limit, :only => [:create]
  before_filter :find_brand
  
  def create
    @query = @brand.add_query(params[:query][:term]) unless params[:query][:term].blank?
    if @query && !@query.new_record?
      flash[:notice] = "Added query term."
    else
      flash[:error] = "Query term not added."
    end
    redirect_to edit_brand_path(@brand)
  end
  
  def destroy
    @query = @brand.queries.find(params[:id])
    @brand.remove_query(@query)
    flash[:notice] = "Deleted query term."
    redirect_to edit_brand_path(@brand)    
  end
  
  private
    def find_brand
      @brand = Brand.find(params[:brand_id])
    end
end