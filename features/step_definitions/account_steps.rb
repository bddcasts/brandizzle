Given /^I log in with login: "([^\"]*)", password: "([^\"]*)"$/ do |login, password|
  user = User.find_by_login(login) || Factory.create(:user, :login => login, :password => password)
  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "#{password}"}
   And %Q{I press "Login"}
end

Given /^I am logged in$/ do
  Given %Q{I log in with login: "my_login", password: "secret"}
end