When /^I delete query term "([^\"]*)"$/ do |query_term|
  query = Query.find_by_term(query_term)
  click_link("delete_query_#{query.id}")
end

Given /^#{capture_model} has the following results for #{capture_model}:$/ do |query, brand, table|
  table.hashes.each do |result|
    follow_up = result.delete("follow_up")
    r = Factory.create(:result, result)
    
    Factory.create(:search_result, :query => model(query), :result => r)
    Factory.create(:brand_result, :brand => model(brand), :result => r, :follow_up => follow_up)
  end
end

Given /^#{capture_model} has (\d+) results for #{capture_model}$/ do |query, results, brand|
  1.upto(results.to_i) do |index|
    r = Factory.create(:result, :body => "Result ##{index}")
    
    Factory.create(:search_result, :query => model(query), :result => r)
    Factory.create(:brand_result, :brand => model(brand), :result => r)
  end
end

Then /^I should see the following results:$/ do |table|
  table.hashes.each do |result|
    response.should have_tag("tr") do
      with_tag("td", result["message"])
      with_tag("td", Time.parse(result["created_at"]).to_s(:short))
    end
  end
end