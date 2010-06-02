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
  Given %Q{an account: "#{login}_account" exists with holder: user "#{login}", team: team "#{login}_team"}

  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end

Given /^I am logged in as subscribed account holder "([^\"]*)"$/ do |login|
  Given %Q{a team: "#{login}_team" exists}
  Given %Q{a user: "#{login}" exists with login: "#{login}", team: team "#{login}_team"}
  Given %Q{a subscribed_account: "#{login}_account" exists with holder: user "#{login}", team: team "#{login}_team", card_token: "ctok", subscription_id: "subs"}

  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end