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

Factory.define(:brand_query) do |f|
  f.association :brand
  f.association :query
end

Factory.define(:brand_result) do |f|
  f.association :brand
  f.association :result
  f.follow_up false
end

Factory.define(:search_result) do |f|
  f.association :query
  f.association :result
end

Factory.define(:account) do |f|
  f.association :holder, :factory => :user
end

Factory.define(:user) do |f|
  f.sequence(:login) { |i| "user-#{i}"}
  f.email { |u| "#{u.login}@example.com"}
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.active true
  f.association :invitation
end

Factory.define(:account_holder, :parent => :user) do |f|
  f.association :account
end

Factory.define(:invitation) do |f|
  f.sequence(:recipient_email) { |i| "invited-user-#{i}@example.com" }
end