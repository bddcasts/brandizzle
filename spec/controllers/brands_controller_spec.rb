require File.dirname(__FILE__) + '/../spec_helper'

describe BrandsController do
  before(:each) do
    @brand = mock_model(Brand)
  end
  
  describe "handling GET index" do
    before(:each) do
      @brands = [@brand]
    end
    
    def do_get
      get :index
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
      Brand.stub!(:find).and_return(@brand)
    end
    
    def do_get
      get :edit, :id => 37
    end
    
    it "should find the specified brand and assign it for the view" do
      Brand.should_receive(:find).with("37").and_return(@brand)
      do_get
      assigns[:brand].should == @brand
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template(:edit)
    end
  end

end
