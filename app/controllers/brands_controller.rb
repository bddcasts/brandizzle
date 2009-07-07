class BrandsController < ApplicationController
  def index
    @brands = Brand.find(:all)
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
  end
end