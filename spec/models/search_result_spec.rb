require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchResult do
  it { should have_column(:body, :type => :text) }
  it { should have_column(:source, :url, :type => :string) }
  it { should have_index(:url).unique(true) }
  it { should belong_to(:search) }
  
  it {
    Factory.create(:search_result)
    should validate_uniqueness_of(:url)
  }

  describe ".latest" do
    it "finds the latest search results for a given brand" do
      @brand1 = Factory.create(:brand)
      @results = (1..5).map { |i|
        Factory.create(:search_result,
          :created_at => i.hours.ago,
          :search => Factory.create(:search, :brand => @brand1)) }
      SearchResult.latest(:brand_id => @brand1.id).should == @results
    end
    
    it "finds the latest search results for a given source" do
      @blog_results = (1..5).map { |i|
        Factory.create(:search_result,
          :created_at => i.hours.ago,
          :source => 'blog') }
      @twit_results = (1..5).map { Factory.create(:search_result, :source => 'twitter') }
      SearchResult.latest(:source => 'blog').should == @blog_results
    end
    
    it "finds the latest search results for given page" do
      @all_searches = (1..20).map { |i|
        Factory.create(:search_result, :created_at => i.hours.ago, :search => nil)
      }
      SearchResult.latest(:page => 1).should == @all_searches[0..14]
    end
  end

  it "does not create duplicate entries for same URL" do
    @search_result = Factory.create(:search_result)
    lambda {
      Factory.build(:search_result, :url => @search_result.url).save
    }.should_not change(SearchResult, :count)
  end
end
