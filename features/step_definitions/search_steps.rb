Given /^there is a search "([^\"]*)" for "([^\"]*)"$/ do |term, brand_name|
  brand = Brand.find_by_name(brand_name)
  brand.searches.create!(:term => term)
end

When /^I delete search term "([^\"]*)"$/ do |search_term|
  search = Search.find_by_term(search_term)
  click_button("delete_search_#{search.id}")
end