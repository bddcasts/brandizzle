Factory.define(:brand) do |f|
  f.sequence(:name) { |i| "Brand #{i}" }
end