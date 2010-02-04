require File.dirname(__FILE__) + '/../spec_helper'

describe ActivationsController do
  describe "handling GET new" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find_using_perishable_token).and_return(@user)
      
      @user.stub!(:active?).and_return(false)
      @user.stub!(:activate!).and_return(true)
      @user.stub!(:deliver_activation_confirmation!)
      
      UserSession.stub!(:create)
    end
    
    def do_get
      get :new, :activation_code => "foo"
    end
    
    it "finds the user by perishable token and assigns it for the view" do
      User.should_receive(:find_using_perishable_token).with("foo", anything()).and_return(@user)
      do_get
      assigns[:user].should == @user
    end
    
    it "activates the user" do
      @user.should_receive(:activate!).and_return(true)
      do_get
    end
    
    it "logs in the user" do
      UserSession.should_receive(:create).with(@user)
      do_get
    end
    
    it "sets the flash message and redirects to home page" do
      do_get
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
  end
end
