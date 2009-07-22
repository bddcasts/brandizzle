require File.dirname(__FILE__) + '/../spec_helper'

describe SearchResultsController do
  describe "handling POST follow up" do
    before(:each) do
      @search_result = mock_model(SearchResult, :toggle_follow_up => nil)
      SearchResult.stub!(:find).and_return(@search_result)
    end
    
    def do_post
      post :follow_up, :id => 42
    end
    
    it "should find the search result by id and assign it for the view" do
      SearchResult.should_receive(:find).with("42").and_return(@search_result)
      do_post
      assigns[:search_result].should == @search_result
    end
    
    it "should tell the model to change follow up status for search result" do
      @search_result.should_receive(:toggle_follow_up)
      do_post
    end
    
    it "should redirect to the current page" do
      do_post
      response.should be_redirect      
    end
  end
end
