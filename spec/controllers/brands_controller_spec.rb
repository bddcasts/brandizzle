require File.dirname(__FILE__) + '/../spec_helper'

describe BrandsController do
  describe "access_control" do
    [:index, :new, :create, :edit, :update, :destroy].each do |action|
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
      
      [:index, :new, :create, :edit, :update, :destroy].each do |action|
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
      
      [:index, :new, :create, :edit, :update, :destroy].each do |action|
        it "requires a subscribed account #{action}" do
          get action
          flash[:notice].should == "The subscription for this account has expired. Please inform your account holder."
          response.should redirect_to(new_user_session_path)
        end
      end
    end
  end

  describe "actions" do
    before(:each) do
      login_user
      @current_team = current_user.team
    end

    describe "handling GET index" do
      before(:each) do
        @brands = (1..3).map{ mock_model(Brand) }
        @current_team.stub!(:brands).and_return(@brands)
      end
    
      def do_get
        get :index
      end
    
      it "finds the current user's brands and assigns them for the view" do
        @current_team.should_receive(:brands).and_return(@brands)
        do_get
        assigns[:brands].should == @brands
      end
    
      it "renders the index template" do
        do_get
        response.should render_template(:index)
      end
    end

    describe "handling GET new" do
      before(:each) do
        @brand = mock_model(Brand)
        @current_team.stub_chain(:brands, :build).and_return(@brand)
      end
    
      def do_get
        get :new
      end
    
      it "should build an empty brand and assign it for the view" do
        @current_team.brands.should_receive(:build).and_return(@brand)
        do_get
        assigns[:brand].should == @brand
      end
    
      it "should render the new template" do
        do_get
        response.should render_template(:new)
      end
    end

    describe "handling POST create" do
      before(:each) do
        @brand = mock_model(Brand)
        @current_team.stub_chain(:brands, :build).and_return(@brand)
      end
    
      def post_with_valid_attributes
        @brand.should_receive(:save).and_return(true)
        post :create, :brand => { :name => 'a_new_brand' }
      end
    
      def post_with_invalid_attributes
        @brand.should_receive(:save).and_return(false)
        post :create
      end
    
      it "builds a new Brand from params and assigns it for the view" do
        @current_team.brands.should_receive(:build).with("name" => "a_new_brand").and_return(@brand)
        post_with_valid_attributes
        assigns[:brand].should == @brand
      end
    
      it "sets the flash and redirects to the edit action on success" do
        post_with_valid_attributes
        flash[:notice].should == 'Brand successfully created.'
        response.should redirect_to(edit_brand_path(@brand))
      end
    
      it "renders the new template on failure" do
        post_with_invalid_attributes
        response.should render_template(:new)
      end
    end

    describe "handling GET edit" do
      before(:each) do
        @brand = mock_model(Brand, :user => current_user)
        @current_team.stub_chain(:brands, :find).and_return(@brand)
      
        @query = mock_model(Query)
      end
    
      def do_get
        get :edit, :id => 37
      end  
    
      it "should find the specified brand and assign it for the view" do
        @current_team.brands.should_receive(:find).with("37").and_return(@brand)
        do_get
        assigns[:brand].should == @brand
      end

      it "should create a new query and assign it for the view" do
        Query.should_receive(:new).and_return(@query)
        do_get
        assigns[:query].should == @query
      end
    
      it "should render the edit template" do
        do_get
        response.should render_template(:edit)
      end
    end

    describe "handling PUT update" do
      before(:each) do
        @brand = mock_model(Brand, :user => current_user)
        @current_team.stub_chain(:brands, :find).and_return(@brand)
      end
    
      def put_with_valid_attributes
        @brand.should_receive(:update_attributes).with("name" => "updated brand name").and_return(true)
        put :update, :id => 34, :brand => { :name => "updated brand name" }
      end
    
      def put_with_invalid_attributes
        @brand.should_receive(:update_attributes).and_return(false)
        put :update, :id => 34
      end
    
    
      it "finds the specified brand and assigns it for the view" do
        @current_team.brands.should_receive(:find).with("34").and_return(@brand)
        put_with_valid_attributes
        assigns[:brand].should == @brand
      end
    
      it "should set the flash and redirect to the edit page if update succeeds" do
        put_with_valid_attributes
        response.should redirect_to(edit_brand_path(@brand))
        flash[:notice].should == 'Brand updated.'
      end
    
      it "renders the edit template if brand update fails" do
        put_with_invalid_attributes
        response.should render_template(:edit)
      end
    end
  
    describe "handling DELETE destroy" do
      before(:each) do
        @brand = mock_model(Brand, :user => current_user)
        @current_team.stub_chain(:brands, :find).and_return(@brand)
        @brand.stub!(:destroy).and_return(true)
      end
    
      def do_delete
        delete :destroy, :id => 55
      end
    
      it "finds the specified brand" do
        @current_team.brands.should_receive(:find).with("55").and_return(@brand)
        do_delete
      end
    
      it "destroys the brand" do
        @brand.should_receive(:destroy)
        do_delete
      end
    
      it "sets the flash and redirects to the dashboard" do
        do_delete
        response.should redirect_to(brands_path)
        flash[:notice].should == 'Brand deleted.'
      end
    end
  end
end
