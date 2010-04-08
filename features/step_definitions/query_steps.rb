Given /^#{capture_model} has the following results for #{capture_model}:$/ do |query, brand, table|
  table.hashes.each do |result|
    state = result.delete("state")
    r = Factory.create(:result, result)
    
    Factory.create(:search_result, :query => model(query), :result => r)
    Factory.create(:brand_result, :brand => model(brand), :result => r, :state => state)
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
    page.should have_css('div.result') do
      with_tag("p.body", result["message"])
      with_tag("p.status", Time.parse(result["created_at"]).strftime("%I:%M%p"))
    end
  end
end