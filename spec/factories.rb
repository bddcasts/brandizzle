Factory.define(:brand) do |f|
  f.sequence(:name) { |i| "Brand #{i}" }
end

Factory.define(:search) do |f|
  f.sequence(:term) { |i| "Search term #{i}" }
end

Factory.define(:search_result) do |f|
  f.sequence(:body) { |i| "Search result ##{i}" }
  f.sequence(:url) { |i| "http://twitter.com/someone/statuses/123456#{i}" }
  f.association :search, :factory => :search
end