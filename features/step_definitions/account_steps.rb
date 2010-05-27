Given /^I am logged in as "([^\"]*)"$/ do |login|
  Given %Q{a team: "#{login}_team" exists}
  Given %Q{a user: "#{login}" exists with login: "#{login}", password: "secret"}
  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end

Given /^I am logged in as account holder "([^\"]*)"$/ do |login|
  Given %Q{a team: "#{login}_team" exists}
  Given %Q{a user: "#{login}" exists with login: "#{login}", team: team "#{login}_team"}
  Given %Q{a subscription: "#{login}_subscription" exists}
  Given %Q{an account: "#{login}_account" exists with holder: user "#{login}", team: team "#{login}_team", subscription: subscription "#{login}_subscription"}

  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end

Given /^"([^\"]*)" has invitations to send$/ do |login|
  user = User.find_by_login(login)
  user.invitation_limit = 1
  user.save
end