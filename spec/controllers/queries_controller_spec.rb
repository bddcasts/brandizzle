require File.dirname(__FILE__) + '/../spec_helper'

describe QueriesController do
  describe "access_control" do
    [:create, :destroy].each do |action|
      it "#{action} requires a subscribed account" do
        login_unsubscribed_account_holder
        get action
        flash[:notice].should == "You must be subscribed in order to keep using our services!"
        response.should redirect_to(account_path)
      end
    end
  end  
  
  describe "actions" do
    before(:each) do
      login_user
      @brand = mock_model(Brand, :queries => mock("brand queries"))
      Brand.stub!(:find).and_return(@brand)
      @query = mock_model(Query)
    end
  
    describe "handling POST create" do
      before(:each) do
        @brand.stub!(:add_query).and_return(@query)
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
