Factory.define(:brand) do |f|
  f.sequence(:name) { |i| "Brand #{i}" }
  f.association :team
end

Factory.define(:query) do |f|
  f.sequence(:term) { |i| "Query term #{i}" }
end

Factory.define(:since_query, :parent => :query) do |f|
  f.latest_id "1234"
end

Factory.define(:brand_query) do |f|
  f.association :brand
  f.association :query
end

Factory.define(:search_result) do |f|
  f.association :query
  f.association :result
end

Factory.define(:comment) do |f|
  f.content "Lorem ipsum .."
  f.association :user
  f.association :brand_result
end

