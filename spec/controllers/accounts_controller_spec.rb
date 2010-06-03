require 'spec_helper'

describe AccountsController do
  
  describe "access control" do        
    [:edit, :update, :show].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        flash[:notice].should  == "You must be logged in to access this page"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    [:edit, :update, :show].each do |action|
      it "requires user to be account holder for action #{action}" do
        login_user
        get action
        flash[:notice].should == "Access denied! Only the account holder can modify settings."
        response.should redirect_to(team_path)
      end
    end
  end
  
  describe "handling GET new" do
    before(:each) do
      @account = mock_model(Account)
      @user = mock_model(User)
      
      Account.stub!(:new).and_return(@account)
      @account.stub(:build_holder).and_return(@user)
    end
    
    def do_get(options={})
      get :new, options
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
    
    it "renders the new template with the 'login' template" do
      do_get
      response.should render_template(:new)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      @account = mock_model(Account)
      Account.stub!(:new).and_return(@account)
      
      @team = mock_model(Team)
      @account.stub!(:build_team).and_return(@team)
      @account.stub_chain(:holder, :team=)
      @account.stub_chain(:holder, :deliver_activation_instructions!)
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
      Account.should_receive(:new).with(hash_including("login" => "Cartman")).and_return(@account)
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
    
    it "delivers the activation instructions email" do
      @account.holder.should_receive(:deliver_activation_instructions!)
      do_post_with_valid_attributes
    end
    
    it "sets the flash message and redirects to login page on success" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(new_user_session_path)
    end
    
    it "sets the flash message and renders the new template on failure" do
      do_post_with_invalid_attributes
      # flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end

  describe "handling GET show" do
    before(:each) do
      login_account_holder
      @account = current_user.account
      @account.stub!(:card_token).and_return(true)
    end
    
    def do_get
      get :show
    end
    
    it "assigns the current_user account for the view" do
      current_user.should_receive(:account).and_return(@account)
      do_get
      assigns[:account].should == @account
    end
    
    it "renders the show template" do
      do_get
      response.should render_template(:show)
    end
    
    it "redirects to edit action if account has no card_token set" do
      @account.should_receive(:card_token).and_return(false)
      do_get
      response.should redirect_to(edit_account_path)
    end
  end
  
  describe "handling GET edit" do
    before(:each) do
      login_account_holder
      @account = current_user.account
    end
    
    def do_get
      get :edit
    end
    
    it "assigns the current_user account for the view" do
      current_user.should_receive(:account).and_return(@account)
      do_get
      assigns[:account].should == @account
    end
    
    it "renders the edit template" do
      do_get
      response.should render_template(:edit)
    end
  end
  
  describe "handling PUT update" do
    before(:each) do
      login_account_holder
      @account = current_user.account
    end
    
    def do_put_with_valid_attributes(options={})
      @account.should_receive(:update_attributes).with("first_name" => "Randy").and_return(true)
      put :update, :account => {:first_name => "Randy"}.merge(options)
    end
    
    it "assigns the current_user account for the view" do
      current_user.should_receive(:account).and_return(@account)
      do_put_with_valid_attributes
      assigns[:account].should == @account
    end
    
    it "sets the flash and redirects to show page on success" do
      do_put_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(account_path)
    end
    
    it "sets the flash and renders the edit template on failure" do
      @account.should_receive(:update_attributes).and_return(false)
      put :update
      # flash.now[:error].should_not be_nil
      response.should render_template(:edit)
    end
  end
end
