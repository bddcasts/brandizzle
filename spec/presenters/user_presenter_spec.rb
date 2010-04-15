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
  
  # describe "#action_links" do
  #   before(:each) do
  #     login_user
  #   end
  #   
  #   it "returns empty array if current_user is not account holder" do
  #     presenter = UserPresenter.new(:user => Factory.create(:user))
  #     presenter.controller = mock("MockController", :current_user => current_user)
  #     
  #     presenter.action_links.should be_empty
  #   end
  #   
  #   it "returns empty array for himself if current user is account holder" do
  #     current_user.account = Factory.create(:account)
  #     current_user.save
  #     
  #     presenter = UserPresenter.new(:user => current_user)
  #     presenter.controller = mock("MockController", :current_user => current_user)
  #     
  #     presenter.action_links.should be_empty
  #   end
  #   
  #   it "returns a 'remove' link if current_user is account holder" do
  #     current_user.account = Factory.create(:account)
  #     current_user.save
  #     
  #     presenter = UserPresenter.new(:user => Factory.create(:user, :active => true))
  #     presenter.controller = mock("MockController", :current_user => current_user, :null_object => true)
  #     
  #     presenter.action_links[0].should match(/Remove/)
  #   end
  #   
  #   it "returns a 'disable/enable' link if current_user is account holder" do
  #     current_user.account = Factory.create(:account)
  #     current_user.save
  #     
  #     presenter = UserPresenter.new(:user => Factory.create(:user, :active => true))
  #     presenter.controller = mock("MockController", :current_user => current_user, :null_object => true)
  #     
  #     presenter.action_links[1].should match(/Disable/)
  #   end
  # end
end
