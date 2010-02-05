Given /^I am logged in as "([^\"]*)"$/ do |login|
  Given %Q{a user: "#{login}" exists with login: "#{login}", password: "secret"}
  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end