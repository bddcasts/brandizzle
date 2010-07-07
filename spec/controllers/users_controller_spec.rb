require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do  
  describe "access_control" do
    [:new, :create, :edit, :update, :destroy, :alter_status].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        flash[:notice].should == "You must be logged in to access this page"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "unsubscribed account holder" do
      before(:each) do
        login_unsubscribed_account_holder
      end
      
      [:new, :create, :edit, :update, :destroy, :alter_status].each do |action|
        it "requires a subscribed account #{action}" do
          get action
          flash[:notice].should == "You must be subscribed in order to keep using our services!"
          response.should redirect_to(account_path)
        end
      end
    end
    
    context "unsubscribed team member" do
      before(:each) do
        login_unsubscribed_user
        user_session.stub(:destroy)
      end
      
      [:new, :create, :edit, :update, :destroy, :alter_status].each do |action|
        it "requires a subscribed account for action #{action}" do
          get action
          flash[:notice].should == "The subscription for this account has expired. Please inform your account holder."
          response.should redirect_to(new_user_session_path)
        end
      end
    end
    
    context "team member" do
      before(:each) do
        login_user
      end
      
      [:new, :create, :destroy, :alter_status].each do |action|
        it "requires user to be account holder for action #{action}" do
          login_user
          get action
          flash[:warning].should == "Access denied! Only the account holder can modify settings."
          response.should redirect_to(team_path)
        end
      end
    end
    
    context "create requires account not have reached the limit of team members" do
      before(:each) do
        login_account_holder
        current_user.account.stub(:team_members_left).and_return(0)
      end
      
      it "sets the flash message and redirects to the account path" do
        get :create
        flash[:warning].should == "You reached the limit of team members. User registration failed."
        response.should redirect_to(account_path)
      end
    end
  end
  
  describe "handling GET new" do
    before(:each) do
      login_account_holder
      @current_team = @current_user.team
      @user = mock_model(User)
      @current_team.stub_chain(:members, :build).and_return(@user)
    end
    
    def do_get(options={})
      get :new, options
    end
    
    it "creates a new user and assigns it for the view" do
      @current_team.members.should_receive(:build).and_return(@user)
      do_get
      assigns[:user].should == @user
    end
        
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
  end

  describe "handling POST create" do
    before(:each) do
      login_account_holder
      current_user.team.account.stub(:team_members_left).and_return(1)
      @current_team = @current_user.team
      @user = mock_model(User)
      @current_team.stub_chain(:members, :build).and_return(@user)
      @user.stub(:build_user_detail)
      @user.stub!(:deliver_user_invitation!)
    end
    
    def do_post_with_valid_attributes(options={})
      @user.should_receive(:save_without_session_maintenance).and_return(true)
      post :create, :user => options
    end
    
    def do_post_with_invalid_attributes(options={})
      @user.should_receive(:save_without_session_maintenance).and_return(false)
      post :create, :user => options
    end
    
    it "creates a new user from params and assigns it for the view" do
      @current_team.members.should_receive(:build).with("login" => "Cartman").and_return(@user)
      do_post_with_valid_attributes(:login => "Cartman")
      assigns[:user].should == @user
    end
    
    it "builds a new user_detail" do
      @user.should_receive(:build_user_detail)
      do_post_with_valid_attributes
    end
    
    it "delivers the user invitation on success" do
      @user.should_receive(:deliver_user_invitation!)
      do_post_with_valid_attributes
    end
    
    it "sets the flash message and redirects to team page on success" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(team_path)
    end
    
    it "sets the flash message and renders the new template on failure" do
      do_post_with_invalid_attributes
      # flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end

  describe "handling GET edit" do
    before(:each) do
      login_user
      @current_team = @current_user.team
      @user = current_user
    end
    
    def do_get
      get :edit, :id => 42
    end
    
    it "assigns the current user for the view" do
      do_get
      assigns[:user].should == @user
    end
        
    it "renders the edit template" do
      do_get
      response.should render_template(:edit)
    end
  end
  
  describe "handling PUT update" do
    before(:each) do
      login_user({}, :create_or_update => true)
      @user = current_user
    end
    
    def do_put_with_valid_attributes(options={})
      current_user.should_receive(:valid?).and_return(true)
      put :update, :id => 42, :user => options
    end
    
    def do_put_with_invalid_attributes(options={})
      current_user.should_receive(:valid?).and_return(false)
      put :update, :id => 42, :user => options
    end
    
    it "assigns the current user for the view" do
      do_put_with_valid_attributes
      assigns[:user].should == current_user
    end
    
    it "assigns the updated attributes" do
      @user.should_receive(:attributes=).with("password" => "secret")
      do_put_with_valid_attributes(:password => "secret")
    end
    
    it "sets the flash message and redirects to the team page on success" do
      do_put_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(edit_user_info_path)
    end
    
    it "renders the edit template on failure" do
      do_put_with_invalid_attributes
      response.should render_template(:edit)
    end
  end

  describe "handling DELETE destroy" do
    before(:each) do
      login_account_holder
      @current_team = @current_user.team
      @user = mock_model(User)
      @current_team.stub_chain(:members, :find).and_return(@user)
    end
    
    def do_delete
      @user.should_receive(:destroy)
      delete :destroy, :id => 42
    end
    
    it "finds the user and assigns it for the view" do
      @current_team.members.should_receive(:find).with("42").and_return(@user)
      do_delete
      assigns[:user].should == @user
    end
    
    it "sets the flash message and redirects to the team page on success" do
      do_delete
      flash[:success].should_not be_nil
      response.should redirect_to(team_path)
    end
  end

  describe "handling POST alter_status" do
    before(:each) do
      login_account_holder
      @current_team = @current_user.team
      @user = mock_model(User)
      @current_team.stub_chain(:members, :find).and_return(@user)
      @user.stub!(:active?)
    end
    
    def do_post
      @user.should_receive(:toggle_active)
      post :alter_status, :id => 42
    end
    
    it "finds the user and assigns it for the view" do
      @current_team.members.should_receive(:find).with("42").and_return(@user)
      do_post
      assigns[:user].should == @user
    end
    
    it "sets the flash message and redirects to the team page" do
      do_post
      flash[:success].should_not be_nil
      response.should redirect_to(team_path)
    end
  end
end
