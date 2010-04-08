class UserSession < Authlogic::Session::Base
  def self.oauth_consumer
    OAuth::Consumer.new(Settings.twitter.consumer_key, Settings.twitter.consumer_secret,
    { :site => "http://twitter.com",
      :authorize_url => "http://twitter.com/oauth/authenticate" })
  end
end