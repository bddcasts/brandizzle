class BrandsController < ApplicationController
  def index
    @brands = Brand.find(:all)
  end
end