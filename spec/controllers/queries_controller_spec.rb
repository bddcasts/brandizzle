require File.dirname(__FILE__) + '/../spec_helper'

describe QueriesController do
  describe "access_control" do
    [:create, :destroy].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        flash[:notice].should == "You must be logged in to access this page"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "unsubscribed account holder" do
      [:create, :destroy].each do |action|
        before(:each) do
          login_unsubscribed_account_holder
        end
        
        it "requires a subscribed account for action #{action}" do
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
      
      [:create, :destroy].each do |action|
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
      
      [:create, :destroy].each do |action|
        it "requires user to be account holder for action #{action}" do
          login_user
          get action
          flash[:warning].should == "Access denied! Only the account holder can modify settings."
          response.should redirect_to(team_path)
        end
      end
    end
    
    context "create requires account not have reached the limit of search terms" do
      before(:each) do
        login_account_holder
        current_user.account.stub(:search_terms_left).and_return(0)
      end
      
      it "sets the flash message and redirects to the account path" do
        get :create
        flash[:warning].should == "You reached the limit of search terms. Query term not added."
        response.should redirect_to(account_path)
      end
    end
  end
  
  describe "actions" do
    before(:each) do
      login_account_holder
      @brand = mock_model(Brand, :queries => mock("brand queries"))
      Brand.stub!(:find).and_return(@brand)
      @query = mock_model(Query)
    end
  
    describe "handling POST create" do
      before(:each) do
        @brand.stub!(:add_query).and_return(@query)
        current_user.team.account.stub(:search_terms_left).and_return(1)
      end
    
      def post_with_valid_params
        @query.should_receive(:new_record?).and_return(false)
        post :create, :brand_id => 37, :query => { :term => 'new term' }
      end
    
      def post_with_invalid_params
        @query.should_receive(:new_record?).and_return(true)
        post :create, :brand_id => 37, :query => { :term => 'new term' }
      end
    
      it "should find the brand and assigns it for the view" do
        Brand.should_receive(:find).with("37").and_return(@brand)
        post_with_valid_params
        assigns[:brand].should == @brand
      end
    
      it "should build a query from params and assigns it for the view" do
        @brand.should_receive(:add_query).with("new term").and_return(@query)
        post_with_valid_params
        assigns[:query].should == @query
      end
    
      it "should set the flash and redirect to brand edit page on success" do
        post_with_valid_params
        flash[:notice].should == "Added query term."
        response.should redirect_to(edit_brand_path(@brand))
      end
    
      it "should set the flash and redirect to brand edit page on failure" do
        post_with_invalid_params
        flash[:error].should == "Query term not added."
        response.should redirect_to(edit_brand_path(@brand))
      end
    end

    describe "handling DELETE destroy" do
      before(:each) do
        @brand.queries.stub!(:find).and_return(@query)
        @brand.stub!(:remove_query)
      end
    
      def do_delete
        delete :destroy, :brand_id => 37, :id => 42
      end
    
      it "should find the specified brand and assign it for the view" do
        Brand.should_receive(:find).with("37").and_return(@brand)
        do_delete
        assigns[:brand].should == @brand
      end
    
      it "should find the specified query and assign it for the view" do
        @brand.queries.should_receive(:find).with("42").and_return(@query)
        do_delete
        assigns[:query].should == @query
      end
    
      it "should destroy the query" do
        @brand.should_receive(:remove_query).with(@query)
        do_delete
      end
    
      it "should assign the flash and redirect to the brand edit page" do
        do_delete
        flash[:notice].should == "Deleted query term."
        response.should redirect_to(edit_brand_path(@brand))
      end
    end
  end
end
