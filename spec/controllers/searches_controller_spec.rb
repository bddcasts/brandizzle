require File.dirname(__FILE__) + '/../spec_helper'

describe SearchesController do
  
  before(:each) do
    @brand = mock_model(Brand, :searches => mock("brand searches"))
    Brand.stub!(:find).and_return(@brand)
    @search = mock_model(Search)
  end
  
  describe "handling POST create" do
    before(:each) do
      @brand.stub!(:add_search).and_return(@search)
    end
    
    def post_with_valid_params
      @search.should_receive(:new_record?).and_return(false)
      post :create, :brand_id => 37, :search => { :term => 'new term' }
    end
    
    def post_with_invalid_params
      @search.should_receive(:new_record?).and_return(true)
      post :create, :brand_id => 37, :search => {}
    end
    
    it "should find the brand and assigns it for the view" do
      Brand.should_receive(:find).with("37").and_return(@brand)
      post_with_valid_params
      assigns[:brand].should == @brand
    end
    
    it "should build a search from params and assigns it for the view" do
      @brand.should_receive(:add_search).with("new term").and_return(@search)
      post_with_valid_params
      assigns[:search].should == @search
    end
    
    it "should set the flash and redirect to brand edit page on success" do
      post_with_valid_params
      flash[:notice].should == "Added search term."
      response.should redirect_to(edit_brand_path(@brand))
    end
    
    it "should set the flash and redirect to brand edit page on failure" do
      post_with_invalid_params
      flash[:error].should == "Search term not added."
      response.should redirect_to(edit_brand_path(@brand))
    end
  end

  describe "handling DELETE destroy" do
    before(:each) do
      @brand.searches.stub!(:find).and_return(@search)
      @brand.stub!(:remove_search)
    end
    
    def do_delete
      delete :destroy, :brand_id => 37, :id => 42
    end
    
    it "should find the specified brand and assign it for the view" do
      Brand.should_receive(:find).with("37").and_return(@brand)
      do_delete
      assigns[:brand].should == @brand
    end
    
    it "should find the specified search and assign it for the view" do
      @brand.searches.should_receive(:find).with("42").and_return(@search)
      do_delete
      assigns[:search].should == @search
    end
    
    it "should destroy the search" do
      @brand.should_receive(:remove_search).with(@search)
      do_delete
    end
    
    it "should assign the flash and redirect to the brand edit page" do
      do_delete
      flash[:notice].should == "Deleted search term."
      response.should redirect_to(edit_brand_path(@brand))
    end
  end
end
