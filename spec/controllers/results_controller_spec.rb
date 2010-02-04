require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do
  describe "handling POST follow up" do
    before(:each) do
      @result = mock_model(Result, :toggle_follow_up => nil)
      Result.stub!(:find).and_return(@result)
    end
    
    def do_post
      post :follow_up, :id => 42
    end
    
    it "should find the result by id and assign it for the view" do
      Result.should_receive(:find).with("42").and_return(@result)
      do_post
      assigns[:result].should == @result
    end
    
    it "should tell the model to change follow up status for result" do
      @result.should_receive(:toggle_follow_up)
      do_post
    end
    
    it "should redirect to the current page" do
      do_post
      response.should be_redirect      
    end
  end
end
