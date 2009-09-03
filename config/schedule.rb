every 1.hour, :at => 15 do
  rake "brandizzle:reset_demo"
end

every 1.hour, :at => 45 do
  rake "brandizzle:reset_demo"
end

every 1.hour, :at => 17 do
  runner "Search.run"
end

every 1.hour, :at => 47 do
  runner "Search.run"
end
