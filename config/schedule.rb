every :hour do
  rake "brandizzle:reset_demo"
  runner "Search.run"
end
