require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordResetsController do
  describe "handling GET new" do
    def do_get
      get :new
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find_by_email).and_return(@user)
      
      @user.stub!(:email).and_return("test@example.com")
      @user.stub!(:deliver_password_reset_instructions!)
    end
    
    def do_post_with_valid_attributes(options={})
      post :create, :email => "cartman@example.com"
    end
    
    it "finds the user by email and assigns it for the view" do
      User.should_receive(:find_by_email).with("cartman@example.com").and_return(@user)
      do_post_with_valid_attributes
      assigns[:user].should == @user
    end
    
    it "delivers the password reset instructions" do
      @user.should_receive(:deliver_password_reset_instructions!)
      do_post_with_valid_attributes
    end
    
    it "sets the flash message and redirects to the homepage on success" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
    
    it "sets the flash message and renders the new template on failure" do
      User.stub!(:find_by_email).and_return(nil)
      post :create, :email => "stan@example.com"
      flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end

  describe "handling GET edit" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find_using_perishable_token).and_return(@user)
    end
    
    def do_get
      get :edit, :id => "foo"
    end
    
    it "finds the user by perishable token and assigns it for the view" do
      User.should_receive(:find_using_perishable_token).with("foo").and_return(@user)
      do_get
      assigns[:user].should == @user
    end
    
    it "renders the edit template" do
      do_get
      response.should render_template(:edit)
    end
    
    it "sets the flash message nad redirects to the home page when user not found" do
      User.should_receive(:find_using_perishable_token).with("foo").and_return(nil)
      do_get
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
  end

  describe "handling PUT update" do
    before(:each) do
      @user = mock_model(User)
      User.stub(:find_using_perishable_token).and_return(@user)
      
      @user.stub(:password=)
      @user.stub(:password_confirmation=)
    end
    
    def do_put_with_valid_attributes(options={})
      @user.should_receive(:save).and_return(true)
      put :update, :id => "foo", :user => options
    end
    
    it "finds the user by perishable token and assigns it for the view" do
      User.should_receive(:find_using_perishable_token).with("foo").and_return(@user)
      do_put_with_valid_attributes
      assigns[:user].should == @user
    end
    
    it "sets the flash message and redirects to the home page when invalid token" do
      User.stub(:find_using_perishable_token).and_return(nil)
      put :update, :id => "foo"
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
    
    it "assigns the password and password confirmation to the user" do
      @user.should_receive(:password=).with("foo")
      @user.should_receive(:password_confirmation=).with("bar")
      do_put_with_valid_attributes(:password => "foo", :password_confirmation => "bar")
    end
    
    it "sets the flash message and redirects to the homepage on success" do
      do_put_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
    
    it "renders the edit template on failure" do
      @user.should_receive(:save).and_return(false)
      put :update, :id => "foo", :user => {}
      response.should render_template(:edit)
    end
  end
end
