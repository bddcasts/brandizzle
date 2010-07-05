every 10.minutes do
  runner "Query.run"
end

every 1.day, :at => '2:30 am' do
  runner "Account.update_past_due_subscriptions!"
end
