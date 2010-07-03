Given /^(\d+) brand queries exist for "([^"]*)"'s team$/ do |num, account|
  Given %{a brand "some brand" exists with team: team "#{account}_team"}
  Given %{#{num} brand queries exist with brand: brand "some brand"}
end