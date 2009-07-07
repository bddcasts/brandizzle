Given /^an existing brand "([^\"]*)"$/ do |name|
  Factory.create(:brand, :name => name)
end