require 'spec_helper'

describe ActivationsController do
  describe "handling GET new" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find_using_perishable_token).and_return(@user)
    end
    
    def do_get
      get :new, :activation_code => "test-code"
    end
    
    it "finds the user by perishable_token and assigns it for the view" do
      User.should_receive(:find_using_perishable_token).with("test-code", 1.week).and_return(@user)
      do_get
      assigns[:user].should == @user
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
    
    it "sets the flash and redirects to login page if user not found" do
      User.should_receive(:find_using_perishable_token).and_return(nil)
      do_get
      flash[:notice].should_not be_nil
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find).and_return(@user)
      
      @user.stub(:attributes=)
      @user.stub(:active=)
    end
    
    def do_post_with_valid_attributes(options={})
      @user.should_receive(:save).and_return(true)
      post :create, :id => "42", :user => options
    end
    
    it "finds the user by id and assigns it for the view" do
      User.should_receive(:find).with("42").and_return(@user)
      do_post_with_valid_attributes
      assigns[:user].should == @user
    end
    
    it "assigns the attributes to the user" do
      @user.should_receive(:attributes=).with(hash_including(:password => "foo", :password_confirmation => "bar"))
      do_post_with_valid_attributes(:password => "foo", :password_confirmation => "bar")
    end
    
    it "sets the active flag to true" do
      @user.should_receive(:active=).with(true)
      do_post_with_valid_attributes
    end
    
    it "sets the flash message and redirects to the brand_results page" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
    
    it "sets the flash message and renders the new template on failure" do
      @user.should_receive(:save).and_return(false)
      post :create, :id => "42", :user => {}
      flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end
end
