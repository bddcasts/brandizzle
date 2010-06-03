require 'spec_helper'

describe DashboardController do
  describe "access_control" do
    [:index].each do |action|
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
      @current_team = current_user.team
    end
  
    describe "handling GET index" do
      before(:each) do
        @logs = (1..3).map { mock_model(Log)}
        @current_team.stub_chain(:logs, :paginate).and_return(@logs)
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
    end
  end
end
