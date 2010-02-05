require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Result do
  #columns
  should_have_column :body, :type => :text
  should_have_column :source, :url, :type => :string
  should_have_column :follow_up, :type => :boolean
  
  it { should have_index(:url).unique(true) }
  
  #associations
  should_have_and_belong_to_many :searches
  
  # describe ".find_by_url_or_create" do
  #   it "finds the result by url if exists and assigns the current search to the found result" do
  #     search = Factory.create(:search, :term => "foo")
  #     result = Factory.create(:result, :url => "bar")
  #     Result.find_by_url_or_create("bar", search)
  #     
  #     result.searches.should include(search)
  #   end
  #   
  #   it "creates a new result if not found by url and assigns the current search to it" do
  #     search = Factory.create(:search, :term => "foo")
  # 
  #     lambda {
  #       @searches = Result.find_by_url_or_create("bar", search, {})
  #     }.should change(Result, :count).by(1)
  #     
  #     @searches.should include(search)
  #   end
  # end
  
  describe "#toggle_follow_up" do
    it "should set follow_up to true if not set" do
      @result = Factory.create(:result)
      lambda {
        @result.toggle_follow_up
      }.should change(@result, :follow_up?)
      @result.follow_up?.should be_true
    end
    
    it "should set follow_up to false if set" do
      @result = Factory.create(:result, :follow_up => true)
      lambda {
        @result.toggle_follow_up
      }.should change(@result, :follow_up?)
      @result.follow_up?.should be_false
    end
  end
end
