require 'spec_helper'

describe TeamsController do
  describe "handling GET index" do
    before(:each) do
      login_user
      @current_team = current_user.team
    end
    
    def do_get
      get :index
    end
    
    it "assigns the current team for the view" do
      do_get
      assigns[:team].should == @current_team
    end
  end
end
