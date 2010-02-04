require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchResult do
  it { should have_column(:body, :type => :text) }
  it { should have_column(:source, :url, :type => :string) }
  it { should have_column(:follow_up, :type => :boolean) }
  it { should have_index(:url).unique(true) }
  it { should belong_to(:search) }
  
  it {
    Factory.create(:search_result)
    should validate_uniqueness_of(:url)
  }

  describe "#toggle_follow_up" do
    it "should set follow_up to true if not set" do
      @search_result = Factory.create(:search_result)
      lambda {
        @search_result.toggle_follow_up
      }.should change(@search_result, :follow_up?)
      @search_result.follow_up?.should be_true
    end
    
    it "should set follow_up to false if set" do
      @search_result = Factory.create(:search_result, :follow_up => true)
      lambda {
        @search_result.toggle_follow_up
      }.should change(@search_result, :follow_up?)
      @search_result.follow_up?.should be_false
    end
  end

  it "does not create duplicate entries for same URL" do
    @search_result = Factory.create(:search_result)
    lambda {
      Factory.build(:search_result, :url => @search_result.url).save
    }.should_not change(SearchResult, :count)
  end
end
