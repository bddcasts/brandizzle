require 'spec_helper'

describe UserSession do
  describe ".oauth_consumer" do
    it "buils an OAuth::Consumer and returns it" do
      consumer = mock()
      OAuth::Consumer.
        should_receive(:new).
        with(Settings.twitter.consumer_key, Settings.twitter.consumer_secret, {
          :site => "http://twitter.com",
          :authorize_url => "http://twitter.com/oauth/authenticate" }).
        and_return(consumer)
      UserSession.oauth_consumer.should == consumer
    end
  end
  
end
