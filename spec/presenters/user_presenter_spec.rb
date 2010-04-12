require 'spec_helper'

describe UserPresenter do
  describe "#delegates" do
    before(:each) do
      @user = Factory.create(:user)
      @presenter = UserPresenter.new(:user => @user)
    end
    
    [:id, :login, :email].each do |message|
      it "delegates #{message} to user" do
        @user.should_receive(message)
        @presenter.send(message)
      end
    end
    
    [:current_user, :current_team].each do |message|
      it "delegates ##{message} to controller" do
        @presenter.controller.should_receive(message)
        @presenter.send(message)
      end
    end
  end
  
  describe "#avatar" do
    it "returns the twitter avatar (avatar_url) if user is using Twitter" do
      user = Factory.create(:twitter_user)
      presenter = UserPresenter.new(:user => user)
      presenter.avatar.should == user.avatar_url
    end
    
    it "returns the gravatar is user is not using Twitter" do
      user = Factory.create(:user)
      presenter = UserPresenter.new(:user => user)
      presenter.avatar.should match(/www.gravatar.com/)
    end
  end
end
