class BrandsController < ApplicationController
  def index
    @brands = Brand.all

    @search = Result.search(params[:search])
    @results = @search.paginate(
      :page => params[:page],
      :per_page => 15,
      :include => [:searches => :brands],
      :order => "results.created_at DESC")
  end
  
  def new
    @brand = Brand.new
  end
  
  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      flash[:notice] = "Brand successfully created."
      redirect_to edit_brand_path(@brand)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @brand = Brand.find(params[:id])
    @search = Search.new
  end
  
  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:notice] = "Brand updated."
      redirect_to edit_brand_path(@brand)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    flash[:notice] = "Brand deleted."
    redirect_to brands_path
  end
end