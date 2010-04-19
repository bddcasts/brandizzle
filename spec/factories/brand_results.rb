Factory.define(:result) do |f|
  f.sequence(:body) { |i| "Result ##{i}" }
  f.sequence(:url) { |i| "http://twitter.com/someone/statuses/123456#{i}" }
end

Factory.define(:brand_result) do |f|
  f.association :brand
  f.association :result
  f.state "normal"
end

['follow_up', 'done', 'normal' ].each do |state|
  Factory.define(:"#{state}_brand_result", :parent => :brand_result) do |f|
    f.state state
  end
end

{ "positive" => 1, "neutral" => 0, "negative" => -1}.each do |k, v|
  Factory.define(:"#{k}_brand_result", :parent => :brand_result) do |f|
    f.temperature v
  end
end

Factory.define(:read_brand_result, :parent => :brand_result) do |f|
  f.read true
end