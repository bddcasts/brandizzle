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
  f.state "normal"
end

['follow_up', 'done' ].each do |state|
  Factory.define(:"#{state}_brand_result", :parent => :brand_result) do |f|
    f.state state
  end
end

Factory.define(:search_result) do |f|
  f.association :query
  f.association :result
end

Factory.define(:team) do |f|

end

Factory.define(:account) do |f|
  f.association :holder, :factory => :user
  f.association :invitation
end

Factory.define(:user) do |f|
  f.sequence(:login) { |i| "user-#{i}"}
  f.email { |u| "#{u.login}@example.com"}
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.active true
  f.association :team
  f.account nil
end

Factory.define(:twitter_user, :parent => :user) do |f|
  f.sequence(:name) {|i| "twitter_user_#{i}"}
  f.sequence(:twitter_uid) {|i| i}
  f.oauth_token {|tu| "#{tu.name}_token"}
  f.oauth_secret {|tu| "#{tu.name}_secret"}
end

Factory.define(:inactive_user, :parent => :user) do |f|
  f.active false
end

Factory.define(:invitation) do |f|
  f.sequence(:recipient_email) { |i| "invited-user-#{i}@example.com" }
end