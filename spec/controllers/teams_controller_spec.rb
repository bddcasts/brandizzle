require 'spec_helper'

describe TeamsController do
  describe "access_control" do
    [:show].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        flash[:notice].should == "You must be logged in to access this page"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "account holder" do
      before(:each) do
        login_unsubscribed_account_holder  
      end
      
      [:show].each do |action|
        it "requires a subscribed account for action #{action}" do
          get action
          flash[:notice].should == "You must be subscribed in order to keep using our services!"
          response.should redirect_to(account_path)
        end
      end
    end
    
    context "team member" do
      before(:each) do
        login_unsubscribed_user
        user_session.stub(:destroy)
      end
      
      [:show].each do |action|
        it "requires a subscribed account for action #{action}" do
          get action
          flash[:notice].should == "The subscription for this account has expired. Please inform your account holder."
          response.should redirect_to(new_user_session_path)
        end
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
