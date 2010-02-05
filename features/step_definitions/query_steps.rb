Given /^there is a query "([^\"]*)" for "([^\"]*)"$/ do |term, brand_name|
  brand = Brand.find_by_name(brand_name)
  brand.add_query(term)
end

When /^I delete query term "([^\"]*)"$/ do |query_term|
  query = Query.find_by_term(query_term)
  click_link("delete_query_#{query.id}")
end

Given /^"([^\"]*)" has the following results:$/ do |query_term, table|
  query = Query.find_by_term(query_term)
  table.hashes.each do |result|
    query.results.create!(result)
  end
end

Given /^"([^\"]*)" has (\d+) results$/ do |query_term, results|
  query = Query.find_by_term(query_term)
  1.upto(results.to_i) do |index|
    query.results.create!(
      :body => "Result ##{index}", 
      :url => "http://www.example-#{index}.com/foo",
      :created_at => index.hours.ago)
  end
end

Then /^I should see the following results:$/ do |table|
  table.hashes.each do |result|
    # response.should contain(result["message"])
    response.should have_tag("tr") do
      with_tag("td", result["message"])
      with_tag("td", Time.parse(result["created_at"]).to_s(:short))
    end
  end
end