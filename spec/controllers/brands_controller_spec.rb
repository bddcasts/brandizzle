require File.dirname(__FILE__) + '/../spec_helper'

describe BrandsController do
  before(:each) do
    @brand = mock_model(Brand)
    Brand.stub!(:find).and_return(@brand)
    @results = (1..10).map { mock_model(SearchResult) }
  end
  
  describe "handling GET index" do
    before(:each) do
      @brands = [@brand]
    end
    
    def do_get(options={})
      get :index, options
    end
    
    it "should find all the brands and assign them for the view" do
      Brand.should_receive(:find).with(:all).and_return(@brands)
      do_get
      assigns[:brands].should == @brands
    end
    
    it "should render the index template" do
      do_get
      response.should render_template(:index)
    end
    
    it "finds the latest search results for the given page and filters and assigns them for the view" do
      SearchResult.
        should_receive(:latest).
        with(:page => "12", :brand_id => '45', :source => 'blog', :flag => 'follow up').
        and_return(@results)
      do_get(:page => 12, :brand_id => '45', :source => 'blog', :flag => 'follow up')
      assigns[:results].should == @results
    end
    
  end

  describe "handling GET new" do
    def do_get
      get :new
    end
    
    it "should build an empty brand and assign it for the view" do
      Brand.should_receive(:new).and_return(@brand)
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
      Brand.stub!(:new).and_return(@brand)
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
      Brand.should_receive(:new).with("name" => "a_new_brand").and_return(@brand)
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
      @search = mock_model(Search)
    end
    
    def do_get
      get :edit, :id => 37
    end  
    
    it "should find the specified brand and assign it for the view" do
      Brand.should_receive(:find).with("37").and_return(@brand)
      do_get
      assigns[:brand].should == @brand
    end

    it "should create a new search and assign it for the view" do
      Search.should_receive(:new).and_return(@search)
      do_get
      assigns[:search].should == @search
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template(:edit)
    end
  end

  describe "handling PUT update" do
    def put_with_valid_attributes
      @brand.should_receive(:update_attributes).with("name" => "updated brand name").and_return(true)
      put :update, :id => 34, :brand => { :name => "updated brand name" }
    end
    
    def put_with_invalid_attributes
      @brand.should_receive(:update_attributes).and_return(false)
      put :update, :id => 34
    end
    
    
    it "finds the specified brand and assigns it for the view" do
      Brand.should_receive(:find).with("34").and_return(@brand)
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
      @brand.stub!(:destroy).and_return(true)
    end
    
    def do_delete
      delete :destroy, :id => 55
    end
    
    it "finds the specified brand" do
      Brand.should_receive(:find).with("55").and_return(@brand)
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
