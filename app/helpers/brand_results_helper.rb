module BrandResultsHelper
  def present_brand_result(brand_result)
    BrandResultPresenter.new(:brand_result => brand_result)
  end
  
  def brand_result_with_presenter(brand_result, &block)
    yield BrandResultPresenter.new(:brand_result => brand_result)
  end
end