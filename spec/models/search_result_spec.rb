require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchResult do
  it { should have_column(:body, :type => :text) }
  it { should have_column(:source, :url, :type => :string) }
  it { should belong_to(:search) }

  describe ".latest" do
    before(:each) do
      @all_searches = (1..40).map { |i|
        Factory.create(:search_result, :created_at => i.hours.ago)
      }
    end
    
    it "finds the latest search results for given page" do
      SearchResult.latest(:page => 1).should == @all_searches[0..14]
    end
  end
end
