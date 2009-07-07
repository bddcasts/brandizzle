require File.dirname(__FILE__) + '/../spec_helper'

describe BrandsController do
  describe "handling GET index" do
    before(:each) do
      @brand_1 = mock_model(Brand)
      @brands = [@brand_1]
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
end
