Given /^I am logged in as "([^\"]*)"$/ do |login|
  Given %Q{a team: "#{login}_team" exists}
  Given %Q{a user: "#{login}" exists with login: "#{login}", password: "secret"}
  Given %Q{a user detail exists with user: user "#{login}"}
  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end

Given /^I am logged in as account holder "([^\"]*)"(?: registered "([^\"]*)")?$/ do |login, registered_on|
  Given %Q{a team: "#{login}_team" exists}
  Given %Q{a user: "#{login}" exists with login: "#{login}", team: team "#{login}_team"}
  Given %Q{a user detail exists with user: user "#{login}"}
  
  account_options = [
    %{holder: user "#{login}"},
    %{team: team "#{login}_team"}
  ]
  
  account_options << %{created_at: "#{Chronic.parse(registered_on)}"} unless registered_on.blank?
  
  Given %Q{an account: "#{login}_account" exists with #{account_options.join(', ')}}

  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end

Given /^I am logged in as subscribed account holder "([^\"]*)"(?: registered "([^\"]*)")?$/ do |login, registered_on|
  Given %Q{a team: "#{login}_team" exists}
  Given %Q{a user: "#{login}" exists with login: "#{login}", team: team "#{login}_team"}
  Given %Q{a user detail exists with user: user "#{login}"}
  
  account_options = [
    %{holder: user "#{login}"},
    %{team: team "#{login}_team"},
    %{card_token: "ctok"},
    %{subscription_id: "subs"}
  ]
  
  account_options << %{created_at: "#{Chronic.parse(registered_on)}"} unless registered_on.blank?
  
  Given %Q{an subscribed account: "#{login}_account" exists with #{account_options.join(', ')}}

  When %Q{I am on the login page}
   And %Q{I fill in "Login" with "#{login}"}
   And %Q{I fill in "Password" with "secret"}
   And %Q{I press "Login"}
end

Then /^I should see the following account details:$/ do |expected_table|
  re = /date\(([^\)]*)\)/
  
  expected_table.map_column!('Value') do |text|
    date = text[re, 1]
    date && Chronic.parse(date).strftime('%B %d, %Y') || text
  end
  
  doc_table_diff(expected_table) do |doc, actual_table|
    actual_table << %w[Label Value]
    
    doc.css('#plan-info tr').each do |tr|
      th, td = [tr.at_css('th'), tr.at_css('td')].map { |v| v.content.strip }
      
      date = td[re, 1]
      
      td.gsub!(re, Chronic.parse(date).strftime("%d %b, %Y")) if date
      
      actual_table << [th, td]
    end
  end
end
