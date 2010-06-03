require 'spec_helper'

describe TeamsController do
  describe "access_control" do
    [:show].each do |action|
      it "#{action} requires a subscribed account" do
        login_unsubscribed_account_holder
        get action
        flash[:notice].should == "You must be subscribed in order to keep using our services!"
        response.should redirect_to(account_path)
      end
    end
  end
  
  describe "handling GET show" do
    before(:each) do
      login_user
      @current_team = current_user.team
    end
    
    def do_get
      get :show
    end
    
    it "assigns the current team for the view" do
      do_get
      assigns[:team].should == @current_team
    end
  end
end
