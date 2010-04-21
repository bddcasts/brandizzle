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
  
  describe "handling GET show" do
    before(:each) do
      @brand_result = mock_model(BrandResult, :read? => false)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      @brand_result.stub!(:mark_as_read!)
      
      @comments = (1..3).map{ mock_model(Comment) }
      @brand_result.stub!(:comments).and_return(@comments)
      
      @comment = mock_model(Comment)
      Comment.stub(:new).and_return(@comment)
    end
    
    def do_get(options={})
      get :show, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_result and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_get
      assigns[:brand_result].should == @brand_result
    end
    
    it "marks the result as read if not already marked" do
      @brand_result.should_receive(:mark_as_read!)
      do_get
    end
    
    it "does not mark the result as if already marked" do
      @brand_result.should_receive(:read?).and_return(true)
      @brand_result.should_not_receive(:mark_as_read!)
      do_get
    end
    
    it "finds the brand_result's comments and assigns them for the view" do
      @brand_result.
        should_receive(:comments).
        and_return(@comments)
      do_get
      assigns[:comments].should == @comments
    end
    
    it "created a new comment and assigns it for the view" do
      Comment.should_receive(:new)
      do_get
      assigns[:comment].should == @comment
    end
    
    it "renders the show template" do
      do_get
      response.should render_template(:show)
    end
  end
  
  describe "handling PUT follow_up" do
    before(:each) do
      @log = LogService.new
      LogService.stub!(:new).and_return(@log)
      @log.stub!(:updated_brand_result)
      Log.stub!(:create)
      
      @brand_result = mock_model(BrandResult, :state => 'follow_up', :read? => false)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:follow_up!)
      @brand_result.stub!(:mark_as_read!)
    end
    
    def do_put(options={})
      put :follow_up, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "follows up the brand result (sets state on 'follow_up')" do
      @brand_result.should_receive(:follow_up!)
      do_put
    end
    
    it "marks the result as read if not already read" do
      @brand_result.should_receive(:mark_as_read!)
      do_put
    end
    
    it "does not mark the result as read if already marked" do
      @brand_result.should_receive(:read?).and_return(true)
      @brand_result.should_not_receive(:mark_as_read!)
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
        xhr :put, :follow_up, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
    
    it "send a message to the log action service to create a log for the action" do
      @log.should_receive(:updated_brand_result).with(@brand_result, current_user, hash_including("state" => "follow_up"))
      do_put
    end
  end
  
  describe "handling PUT finish" do
    before(:each) do
      @log = LogService.new
      LogService.stub!(:new).and_return(@log)
      @log.stub!(:updated_brand_result)
      Log.stub!(:create)
      
      @brand_result = mock_model(BrandResult, :state => 'done')
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:finish!)
    end
    
    def do_put(options={})
      put :finish, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "finishes the brand result (sets state on 'done')" do
      @brand_result.should_receive(:finish!)
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
        xhr :put, :finish, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
    
    it "send a message to the log action service to create a log for the action" do
      @log.should_receive(:updated_brand_result).with(@brand_result, current_user, hash_including("state" => "done"))
      do_put
    end
  end
  
  describe "handling PUT reject" do
    before(:each) do
      @log = LogService.new
      LogService.stub!(:new).and_return(@log)
      @log.stub!(:updated_brand_result)
      Log.stub!(:create)
      
      @brand_result = mock_model(BrandResult, :state => 'normal')
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:reject!)
    end
    
    def do_put(options={})
      put :reject, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "finishes the brand result (sets state on 'normal')" do
      @brand_result.should_receive(:reject!)
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
        xhr :put, :reject, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
    
    it "send a message to the log action service to create a log for the action" do
      @log.should_receive(:updated_brand_result).with(@brand_result, current_user, hash_including("state" => "normal"))
      do_put
    end
  end
  
  describe "handling PUT positive" do
    before(:each) do
      @log = LogService.new
      LogService.stub!(:new).and_return(@log)
      @log.stub!(:updated_brand_result)
      Log.stub!(:create)
      
      @brand_result = mock_model(BrandResult, :temperature => 1)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:warm_up!)
    end
    
    def do_put(options={})
      put :positive, { :id => 42 }.merge(options)
    end
      
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "sets the brand result on positive" do
      @brand_result.should_receive(:warm_up!)
      do_put
    end
      
    context "using HTTP request" do
      it "sets the flash and redirects" do
        do_put
        flash[:notice].should_not be_nil
        response.should be_redirect
      end
    end
    
    context "using XHR request" do
      it "renders the update.js template" do
        xhr :put, :positive, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
    
    it "send a message to the log action service to create a log for the action" do
      @log.should_receive(:updated_brand_result).with(@brand_result, current_user, hash_including("temperature" => 1))
      do_put
    end
  end

  describe "handling PUT neutral" do
    before(:each) do
      @log = LogService.new
      LogService.stub!(:new).and_return(@log)
      @log.stub!(:updated_brand_result)
      Log.stub!(:create)
      
      @brand_result = mock_model(BrandResult, :temperature => 0)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:temperate!)
    end
    
    def do_put(options={})
      put :neutral, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "sets the brand result on neutral" do
      @brand_result.should_receive(:temperate!)
      do_put
    end
      
    context "using HTTP request" do
      it "sets the flash and redirects" do
        do_put
        flash[:notice].should_not be_nil
        response.should be_redirect
      end
    end
    
    context "using XHR request" do
      it "renders the update.js template" do
        xhr :put, :neutral, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
    
    it "send a message to the log action service to create a log for the action" do
      @log.should_receive(:updated_brand_result).with(@brand_result, current_user, hash_including("temperature" => 0))
      do_put
    end
  end

  describe "handling PUT negative" do
    before(:each) do
      @log = LogService.new
      LogService.stub!(:new).and_return(@log)
      @log.stub!(:updated_brand_result)
      Log.stub!(:create)
      
      @brand_result = mock_model(BrandResult, :temperature => -1)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:chill!)
    end
    
    def do_put(options={})
      put :negative, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "sets the brand result on neutral" do
      @brand_result.should_receive(:chill!)
      do_put
    end
      
    context "using HTTP request" do
      it "sets the flash and redirects" do
        do_put
        flash[:notice].should_not be_nil
        response.should be_redirect
      end
    end
    
    context "using XHR request" do
      it "renders the update.js template" do
        xhr :put, :negative, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
    
    it "send a message to the log action service to create a log for the action" do
      @log.should_receive(:updated_brand_result).with(@brand_result, current_user, hash_including("temperature" => -1))
      do_put
    end
  end

  describe "handling PUT mark_as_read" do
    before(:each) do
      @brand_result = mock_model(BrandResult)
      @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
      @brand_result.stub!(:mark_as_read!)
    end
    
    def do_put(options={})
      put :mark_as_read, { :id => 42 }.merge(options)
    end
    
    it "finds the brand_results and assigns it for the view" do
      @current_team.brand_results.
        should_receive(:find).
        with("42").
        and_return(@brand_result)
      do_put
      assigns[:brand_result].should == @brand_result
    end
    
    it "sets the brand result as read" do
      @brand_result.should_receive(:mark_as_read!)
      do_put
    end
      
    context "using HTTP request" do
      it "sets the flash and redirects" do
        do_put
        flash[:notice].should_not be_nil
        response.should be_redirect
      end
    end
    
    context "using XHR request" do
      it "renders the update.js template" do
        xhr :put, :mark_as_read, { :id => 42 }
        response.should render_template("update.js.haml")
      end
    end
  end

  describe "handling POST mark_all_as_read" do
    before(:each) do
      @brand_results = (1..3).map { mock_model(BrandResult) }
      @search = mock(Searchlogic::Search, :all => @brand_results)
      @current_team.stub_chain(:brand_results, :unread_before, :search).and_return(@search)
    end
    
    def do_post(options={})
      post :mark_all_as_read, options
    end
    
    it "creates a new search for the brand results and assigns it for the view" do
      @current_team.brand_results.unread_before.
        should_receive(:search).
        with(hash_including("follow_up" => "test")).
        and_return(@search)
       
      do_post(:search => {:follow_up => "test"}) 
      assigns[:search].should == @search
    end
    
    it "fetches all brand results and assigns them for the view" do
      @search.should_receive(:all).
        and_return(@brand_results)
      do_post
      
      assigns[:brand_results].should == @brand_results
    end
    
    it "updates all found brand_results" do
      BrandResult.
        should_receive(:update_all).
        with({:read => true}, {:id => @brand_results})
      
      do_post
    end
    
    it "redirects to brand results index" do
      do_post
      response.should redirect_to(brand_results_path)
    end
  end
end
