When /^I follow "([^\"]*)" for #{capture_model}$/ do |link, target|
  record = model(target)
  with_scope("##{dom_id(record)}") do
    click_link(link)
  end
end

Then /^I should see "([^\"]*)" for #{capture_model}$/ do |text, target|
  record = model(target)
  with_scope("##{dom_id(record)}") do
    page.should have_content(text)
  end
end

Then /^I should not see "([^\"]*)" for #{capture_model}$/ do |text, target|
  record = model(target)
  with_scope("##{dom_id(record)}") do
    page.should have_no_content(text)
  end
end