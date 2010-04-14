require 'spec_helper'

describe UserPresenter do
  describe "#delegates" do
    before(:each) do
      @user = Factory.create(:user)
      @presenter = UserPresenter.new(:user => @user)
    end
    
    [:id, :login, :email, :active?, :has_no_credentials?, :avatar].each do |message|
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
end
