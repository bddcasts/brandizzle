class BrandsController < ApplicationController
  before_filter :require_user
  
  def index
    @brands = current_user.brands

    @search = Result.search(params[:search]) #((params[:search] || {}).merge(:queries_brands_user_id_is => current_user.id))
    @results = @search.paginate(
      :page => params[:page],
      :per_page => 15,
      :include => [:queries => :brands],
      :order => "results.created_at DESC")
  end
  
  def new
    @brand = current_user.brands.build
  end
  
  def create
    @brand = current_user.brands.build(params[:brand])
    if @brand.save
      flash[:notice] = "Brand successfully created."
      redirect_to edit_brand_path(@brand)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @brand = current_user.brands.find(params[:id])
    @query = Query.new
  end
  
  def update
    @brand = current_user.brands.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:notice] = "Brand updated."
      redirect_to edit_brand_path(@brand)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @brand = current_user.brands.find(params[:id])
    @brand.destroy
    flash[:notice] = "Brand deleted."
    redirect_to brands_path
  end
end