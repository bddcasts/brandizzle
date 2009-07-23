require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brand do
  it { should have_column(:name, :type => :string) }
  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:searches) }
  
  describe "#add_search" do
    before(:each) do
      @brand = Factory.create(:brand)
    end
    
    it "creates a new search associated if it does not exist yet" do
      lambda {
        @brand.add_search('foo')
      }.should change(Search, :count)
      @brand.searches.map(&:term).should include('foo')
    end
    
    it "for an existing search it associates it with the brand and does not create a new one" do
      @search = Factory.create(:search, :term => 'foo')
      lambda {
        @brand.add_search('foo')
      }.should_not change(Search, :count)
      @brand.searches.map(&:term).should include('foo')
    end
    
    it "returns the search" do
      @search = @brand.add_search('foo')
      @search.term.should == 'foo'
    end
  end
  
  describe "#remove_search" do
    before(:each) do
      @brand = Factory.create(:brand)
      @bar_search = @brand.add_search('bar')
    end
    
    it "removes the search from the brand" do
      @brand.remove_search(@bar_search)
      @brand.searches.map(&:term).should_not include('bar')
    end
    
    it "does not destroy the search if it is associated to any brand" do
      another_brand = Factory.create(:brand)
      another_brand.add_search('bar')
      lambda {
        @brand.remove_search(@bar_search)
      }.should_not change(Search, :count)
    end
    
    it "destroys the search if it is no longer associated to any brand" do
      lambda {
        @brand.remove_search(@bar_search)
      }.should change(Search, :count).by(-1)
      Search.find_by_term('bar').should be_nil
    end
    
    it "does nothing for a search not associated with the brand" do
      another_brand = Factory.create(:brand)
      foo_search = another_brand.add_search('foo')
      lambda {
        @brand.remove_search(foo_search)
      }.should_not change(Search, :count)
    end
  end
end
