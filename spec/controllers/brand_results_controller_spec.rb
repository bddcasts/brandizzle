require File.dirname(__FILE__) + '/../spec_helper'

describe BrandResultsController do
  before(:each) do
    login_user
    @current_team = current_user.team
  end
  
  describe "handling GET index" do
    before(:each) do
      @brands = (1..3).map{ |i| mock_model(Brand) }
      @current_team.stub!(:brands).and_return(@brands)
      
      @brand_results = (1..3).map { mock_model(BrandResult) }
      @search = mock(Searchlogic::Search, :paginate => @brand_results)
      @current_team.stub_chain(:brand_results, :search).and_return(@search)
    end
    
    def do_get(options={})
      get :index, options
    end
    
    it "finds the users brands and assigns them for the view" do
      @current_team.should_receive(:brands).and_return(@brands)
      do_get
      assigns[:brands].should == @brands
    end
    
    it "creates a new search for the brand results and assigns it for the view" do
      @current_team.brand_results.should_receive(:search).
        with(hash_including("follow_up" => "test")).
        and_return(@search)
       
      do_get(:search => {:follow_up => "test"}) 
      assigns[:search].should == @search
    end
    
    it "paginates the brand results and assigns them for the view" do
      @search.should_receive(:paginate).
        with(hash_including(:page => "3")).
        and_return(@brand_results)
      do_get(:page => 3)
      
      assigns[:brand_results].should == @brand_results
    end
    
    it "renders the index template" do
      do_get
      response.should render_template(:index)
    end
  end
  
  describe "handling POST follow up" do
    before(:each) do
      @brand_result = mock_model(BrandResult, :toggle_follow_up => nil)
      BrandResult.stub!(:find).and_return(@brand_result)
    end
    
    def do_post
      post :follow_up, :id => 42
    end
    
    it "should find the brand result by id and assign it for the view" do
      BrandResult.should_receive(:find).with("42").and_return(@brand_result)
      do_post
      assigns[:brand_result].should == @brand_result
    end
    
    it "should tell the model to change follow up status for brand result" do
      @brand_result.should_receive(:toggle_follow_up)
      do_post
    end
    
    it "should redirect to the current page" do
      do_post
      response.should be_redirect      
    end
  end
end
