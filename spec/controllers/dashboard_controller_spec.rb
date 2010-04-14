require 'spec_helper'

describe DashboardController do
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
