When /^I follow "([^\"]*)" for #{capture_model}$/ do |link, target|
  record = model(target)
  with_scope("##{dom_id(record)}") do
    click_link(link)
  end
end