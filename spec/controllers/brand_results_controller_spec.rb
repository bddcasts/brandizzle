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
  
  describe "handling PUT update" do
    before(:each) do
      @brand_result = mock_model(BrandResult)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:follow_up!)
    end
    
    def do_put(options={})
      put :update, { :id => 42, :action_type => "follow_up" }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    context "follow_up" do
      it "follows up the brand result (sets state on 'follow_up')" do
        @brand_result.should_receive(:follow_up!)
        do_put
      end
      
      context "using HTTP request" do
        it "sets the flash message and redirects" do
          do_put
          flash[:notice].should_not be_blank
          response.should be_redirect
        end
      end
      
      context "using XHR request" do
        it "renders the update template" do
          xhr :put, :update, { :id => 42, :action_type => "follow_up" }
          response.should render_template(:update)
        end
      end
    end
    
    context "finish" do
      before(:each) do
        @brand_result.stub!(:finish!)
      end
      
      it "finishes the brand result (sets the state on 'done')" do
        @brand_result.should_receive(:finish!)
        do_put(:action_type => "finish")
      end
      
      context "using HTTP request" do
        it "sets the flash message and redirects" do
          do_put(:action_type => "finish")
          flash[:notice].should_not be_blank
          response.should be_redirect
        end
      end
      
      context "using XHR request" do
        it "renders the update template" do
          xhr :put, :update, { :id => 42, :action_type => "finish" }
          response.should render_template(:update)
        end
      end
    end
    
    context "reject" do
      before(:each) do
        @brand_result.stub!(:reject!)
      end
      
      it "rejects the brand result (sets the state on 'normal')" do
        @brand_result.should_receive(:reject!)
        do_put(:action_type => "reject")
      end
      
      context "using HTTP request" do
        it "sets the flash message and redirects" do
          do_put(:action_type => "reject")
          flash[:notice].should_not be_blank
          response.should be_redirect
        end
      end
      
      context "using XHR request" do
        it "renders the update template" do
          xhr :put, :update, { :id => 42, :action_type => "reject" }
          response.should render_template(:update)
        end
      end
    end
  end
end
