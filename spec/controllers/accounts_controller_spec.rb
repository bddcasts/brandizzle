require 'spec_helper'

describe AccountsController do
  
  describe "access control" do
    it "edit action requires login" do
      get :edit
      response.should redirect_to(new_user_session_path)
    end
    
    it "update action requires login" do
      put :update
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "handling GET new" do
    before(:each) do
      @invitation = mock_model(Invitation, :recipient_email => "test@example.com")
      @account = mock_model(Account)
      @user = mock_model(User, :invitation => @invitation)
      
      Account.stub!(:new).and_return(@account)
      @account.stub(:build_holder).and_return(@user)
      Invitation.stub!(:find_by_token).with("qwerty").and_return(@invitation)
      @user.stub!(:email=)
    end
    
    def do_get(options={})
      get :new, { :invitation_token => "qwerty" }.merge(options)
    end
    
    it "creates a new account and assigns it for the view" do
      Account.should_receive(:new).and_return(@account)
      do_get
      assigns[:account].should == @account
    end
    
    it "builds a new user for account and assigns it for the view" do
      @account.should_receive(:build_holder).and_return(@user)
      do_get
      assigns[:user].should == @user
    end
    
    it "assigns the invitation's recipient email to the user" do
      @user.should_receive(:email=).with("test@example.com")
      do_get
    end
    
    it "renders the new template with the 'login' template" do
      do_get
      response.should render_template(:new, :layout => "login")
    end
    
    it "sets the flash message and redirects to login path if no invitation is present" do
      Invitation.should_receive(:find_by_token).and_return(nil)
      do_get
      flash[:notice].should_not be_nil
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      @account = mock_model(Account)
      Account.stub!(:new).and_return(@account)
      
      @team = mock_model(Team)
      @account.stub!(:build_team).and_return(@team)
      @account.stub_chain(:holder, :team=)
    end
    
    def do_post_with_valid_attributes(options={})
      @account.should_receive(:save).and_return(true)
      post :create, :account => options
    end
    
    def do_post_with_invalid_attributes(options={})
      @account.should_receive(:save).and_return(false)
      post :create, :account => options
    end
    
    it "creates a new account from params and assigns it for the view" do
      Account.should_receive(:new).with("login" => "Cartman").and_return(@account)
      do_post_with_valid_attributes(:login => "Cartman")
      assigns[:account].should == @account
    end
    
    it "builds a new team for the account and assigns it for the view" do
      @account.should_receive(:build_team).and_return(@team)
      do_post_with_valid_attributes
      assigns[:team].should == @team
    end
    
    it "assigns the account team to the account holder" do
      @account.holder.should_receive(:team=).with(@team)
      do_post_with_valid_attributes
    end
    
    it "sets the flash message and redirects to home page on success" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(brand_results_path)
    end
    
    it "sets the flash message and renders the new template on failure" do
      do_post_with_invalid_attributes
      # flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end
end
