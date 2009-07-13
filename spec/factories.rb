Factory.define(:brand) do |f|
  f.sequence(:name) { |i| "Brand #{i}" }
end

Factory.define(:search_result) do |f|
  f.sequence(:body) { |i| "Search result ##{i}" }
  f.url "http://twitter.com/someone/statuses/123456"
end