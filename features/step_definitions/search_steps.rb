Given /^there is a search "([^\"]*)" for "([^\"]*)"$/ do |term, brand_name|
  brand = Brand.find_by_name(brand_name) || Factory.create(:brand, :name => brand_name)
  brand.searches.create!(:term => term)
end

When /^I delete search term "([^\"]*)"$/ do |search_term|
  search = Search.find_by_term(search_term)
  click_button("delete_search_#{search.id}")
end

Given /^"([^\"]*)" has the following search results:$/ do |search_term, table|
  search = Search.find_by_term(search_term)
  table.hashes.each do |result|
    search.results.create!(result)
  end
end

Given /^"([^\"]*)" has (\d+) search results$/ do |search_term, results|
  search = Search.find_by_term(search_term)
  1.upto(results.to_i) do |index|
    search.results.create!(
      :body => "Search result ##{index}", 
      :url => "http://www.example-#{index}.com/foo",
      :created_at => index.hours.ago)
  end
end

Then /^I should see the following search results:$/ do |table|
  table.hashes.each do |result|
    # response.should contain(result["message"])
    response.should have_tag("tr") do
      with_tag("td", result["message"])
      with_tag("td", Time.parse(result["created_at"]).to_s(:short))
    end
  end
end