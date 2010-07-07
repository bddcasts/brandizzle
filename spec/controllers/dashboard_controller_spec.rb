require 'spec_helper'

describe DashboardController do
  describe "access_control" do
    [:index].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        flash[:notice].should == "You must be logged in to access this page"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "account holder" do
      [:index].each do |action|
        before(:each) do
          login_unsubscribed_account_holder
        end
        
        it "requires a subscribed account for #{action}" do
          get action
          flash[:notice].should == "You must be subscribed in order to keep using our services!"
          response.should redirect_to(account_path)
        end
      end
    end

    context "team member" do
      [:index].each do |action|
        before(:each) do
          login_unsubscribed_user
          user_session.stub(:destroy)
        end
        
        it "requires a subscribed account for #{action}" do
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
        @logs = (1..3).map { mock_model(Log)}
        @brand_results = (1..3).map{ mock_model(BrandResult) }
        @comments = (1..3).map{ mock_model(Comment) }
        @brand_results_count = 11
        
        @current_team.stub_chain(:logs, :paginate).and_return(@logs)
        @current_team.stub_chain(:brand_results, :latest_follow_up).and_return(@brand_results)
        @current_team.stub_chain(:comments, :latest).and_return(@comments)
        @current_team.stub_chain(:brand_results, :follow_up, :count).and_return(@brand_results_count)
      end
    
      def do_get(options={})
        get :index, options
      end
    
      it "paginates the logs for the current team and assigns them for the view" do
        @current_team.logs.
          should_receive(:paginate).
          with(hash_including(:page => "7")).
          and_return(@logs)
        do_get(:page => 7)
        assigns[:logs].should == @logs
      end
      
      it "finds the latest follow_up brand_results and assigns them for the view" do
        @current_team.brand_results.
          should_receive(:latest_follow_up).
          and_return(@brand_results)
        do_get
        assigns[:latest_follow_up_brand_results].should == @brand_results
      end
      
      it "counts all the follow_up brand_results and assigns the result to the view" do
        @current_team.brand_results.follow_up.
          should_receive(:count).
          and_return(@brand_results_count)
        do_get
        assigns[:follow_up_brand_results_count].should == @brand_results_count
      end
      
      it "finds the latest comments and assigns them for the view" do
        @current_team.comments.
          should_receive(:latest).
          and_return(@comments)
        do_get
        assigns[:latest_comments].should == @comments
      end
      
      it "renders the index template" do
        do_get
        response.should render_template(:index)
      end
    end
  end
end
