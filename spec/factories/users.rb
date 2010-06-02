Factory.define(:team) do |f|

end

Factory.define(:account) do |f|
  f.association :holder, :factory => :user
end

Factory.define(:subscription_account, :parent => :account) do |f|
  f.plan_id "standard"
  f.sequence(:customer_id) { |i| "1234#{i}"}
  f.sequence(:card_token) { |i| "token#{i}"}
  f.sequence(:subscription_id) { |i| "subs-id-#{i}" }
  f.status "active"
  f.card_first_name "Randy"
  f.card_last_name "Marsh"
  f.card_postal_code "12345"
  f.card_type "Visa"
  f.card_number_last_4_digits "1111"
  f.card_expiration_date "05/2020"
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
  f.avatar_url {|tu| "http://a3.twimg.com/profile_images/#{tu.twitter_uid}/images-2_normal.jpeg"}
  f.oauth_token {|tu| "#{tu.name}_token"}
  f.oauth_secret {|tu| "#{tu.name}_secret"}
end

Factory.define(:inactive_user, :parent => :user) do |f|
  f.active false
end
