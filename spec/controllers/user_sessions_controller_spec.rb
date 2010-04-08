require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  before(:each) do
    activate_authlogic
    @user_session = UserSession.new
  end

  describe "handling GET new" do
    before(:each) do
      UserSession.stub(:find).and_return(nil)
    end
        
    def do_get
      get :new
    end
        
    it "builds a new user session and assigns it for the view" do
      UserSession.should_receive(:new).and_return(@user_session)
      do_get
      assigns[:user_session] == @user_session
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
    
  end
    
  describe "handling POST create" do
    before(:each) do
      UserSession.stub(:find).and_return(nil) # logged out
      UserSession.stub!(:new).and_return(@user_session)
      @user_session.stub!(:record).and_return(stub_model(User, :save => true, :to_s => 'my_login'))
    end
    
    def post_with_valid_attributes(options={})
      @current_user = mock_model(User, :login => options[:user_session].try(:[], :login)) # option[:user_session] && options[:user_session][:login]
      controller.should_receive(:current_user).and_return(nil) # first time it is the filter that sends :current_user, expects nil
      @user_session.should_receive(:valid?).and_return(true)
      post :create, options
    end
    
    def post_with_invalid_attributes(options={})
      @user_session.should_receive(:valid?).and_return(false)
      post :create, options
    end

    it "builds a new User Session from params and assigns it for the view" do
      UserSession.should_receive(:new).with("login" => "my_login").and_return(@user_session)
      post_with_valid_attributes(:user_session => { :login => "my_login" })
      assigns[:user_session].should == @user_session
    end
    
    it "redirects to the results page and sets the flash message on success" do
      post_with_valid_attributes(:user_session => { :login => "my_login" })
      flash[:notice].should == "Welcome my_login!"
      response.should redirect_to(brand_results_path)
    end
    
    it "renders the new template on failure" do
      post_with_invalid_attributes
      response.should render_template(:new)
    end
    
    it "sets the notice flash and redirects to the login page if denied OAuth authentication" do
      post_with_invalid_attributes(:denied => "foo")
      flash[:notice].should == "You did not allow Brandizzle to use your Twitter account"
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "handling DELETE destroy" do
    def do_delete
      delete :destroy
    end
    
    it "redirects to the login page if not logged in" do
      do_delete
      response.should redirect_to(new_user_session_path)
    end
    
    describe "when logged in" do
      before(:each) do
        login_user
        user_session.stub(:destroy)
      end
      
      it "destroys the current user session" do
        user_session.should_receive(:destroy)
        do_delete
      end
      
      it "sets the flash message and redirects to the home page" do
        do_delete
        flash[:notice].should == "Logout successful!"
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end








