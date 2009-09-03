every 4.hours do
  rake "brandizzle:reset_demo"
end

every 15.minutes do
  runner "Search.run"
end