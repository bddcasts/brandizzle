Then /^I should see the following results:$/ do |table|
  table.hashes.each do |result|
    with_scope('div.result') do
      with_scope('div.view_links') do
        page.should have_content(Time.parse(result["created_at"]).strftime("%I:%M%p"))
      end
      with_scope('div.body') do
        page.should have_content(result["content"])
      end
    end
  end
end