module BrandsHelper
  def present_brand(brand)
    BrandPresenter.new(:brand => brand)
  end
end