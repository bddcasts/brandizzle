module BrandResultsHelper
  def present_brand_result(brand_result)
    BrandResultPresenter.new(:brand_result => brand_result)
  end
end