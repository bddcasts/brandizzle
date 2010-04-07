module BrandResultsHelper
  def present_brand_result(brand_result)
    BrandResultPresenter.new(:brand_result => brand_result)
  end
  
  def show_day(day)
    if day.today?
      "Today"
    elsif day.year == Time.now.year
      day.strftime('%B %d')
    else
      day.strftime('%B %d, %Y')
    end
  end
end