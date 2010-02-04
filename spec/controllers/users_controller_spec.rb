require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
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
    def do_get
      get :new
    end
    
    before(:each) do
      @user = mock_model(User)
    end
    
    it "creates a new user and assigns it for the view" do
      User.should_receive(:new).and_return(@user)
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
      @user = mock_model(User)
      User.stub!(:new).and_return(@user)
    end
    
    def do_post_with_valid_attributes(options={})
      @user.should_receive(:save).and_return(true)
      post :create, :user => options
    end
    
    def do_post_with_invalid_attributes(options={})
      @user.should_receive(:save).and_return(false)
      post :create, :user => options
    end
    
    it "creates a new user from params and assigns it for the view" do
      User.should_receive(:new).with("login" => "Cartman").and_return(@user)
      do_post_with_valid_attributes(:login => "Cartman")
      assigns[:user].should == @user
    end
    
    it "sets the flash message and redirects to home page on success" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
    
    it "sets the flash message and renders the new template on failure" do
      do_post_with_invalid_attributes
      flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end
end
