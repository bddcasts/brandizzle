Then /current page for "([^\"]*)" should be (\d+)/ do |scope, current_page|
  with_scope("#{scope} .pagination .current") do
    page.should have_content(current_page)
  end
end