Factory.define(:brand) do |f|
  f.sequence(:name) { |i| "Brand #{i}" }
  f.association :user
end

Factory.define(:query) do |f|
  f.sequence(:term) { |i| "Query term #{i}" }
end

Factory.define(:since_query, :parent => :query) do |f|
  f.latest_id "1234"
end

Factory.define(:result) do |f|
  f.sequence(:body) { |i| "Result ##{i}" }
  f.sequence(:url) { |i| "http://twitter.com/someone/statuses/123456#{i}" }
end

Factory.define(:user) do |f|
  f.sequence(:login) { |i| "user-#{i}"}
  f.email { |u| "#{u.login}@example.com"}
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.active true
end

Factory.define(:inactive_user, :parent => :user) do |f|
  f.active false
end