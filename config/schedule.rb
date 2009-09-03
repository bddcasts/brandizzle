every 1.hour, :at => 15 do
  rake "brandizzle:reset_demo"
end

every 1.hour, :at => 45 do
  rake "brandizzle:reset_demo"
end

every 30.minutes do
  runner "Search.run"
end
