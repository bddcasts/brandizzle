require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brand do
  #columns
  should_have_column :name, :type => :string
  
  #associations
  should_have_many :brand_queries
  should_have_many :queries, :through => :brand_queries
  should_belong_to :user
  
  #validations
  should_validate_presence_of :name
  
  describe "#add_query" do
    before(:each) do
      @brand = Factory.create(:brand)
    end
    
    it "creates a new query associated if it does not exist yet" do
      lambda {
        @brand.add_query('foo')
      }.should change(Query, :count)
      @brand.queries.map(&:term).should include('foo')
    end
    
    it "for an existing query it associates it with the brand and does not create a new one" do
      @query = Factory.create(:query, :term => 'foo')
      lambda {
        @brand.add_query('foo')
      }.should_not change(Query, :count)
      @brand.queries.map(&:term).should include('foo')
    end
    
    it "returns the query" do
      @query = @brand.add_query('foo')
      @query.term.should == 'foo'
    end
  end
  
  describe "#remove_search" do
    before(:each) do
      @brand = Factory.create(:brand)
      @bar_query = @brand.add_query('bar')
    end
    
    it "removes the query from the brand" do
      @brand.remove_query(@bar_query)
      @brand.queries.map(&:term).should_not include('bar')
    end
    
    it "does not destroy the query if it is associated to any brand" do
      another_brand = Factory.create(:brand)
      another_brand.add_query('bar')
      lambda {
        @brand.remove_query(@bar_query)
      }.should_not change(Query, :count)
    end
    
    it "destroys the query if it is no longer associated to any brand" do
      lambda {
        @brand.remove_query(@bar_query)
      }.should change(Query, :count).by(-1)
      Query.find_by_term('bar').should be_nil
    end
    
    it "does nothing for a query not associated with the brand" do
      another_brand = Factory.create(:brand)
      foo_query = another_brand.add_query('foo')
      lambda {
        @brand.remove_query(foo_query)
      }.should_not change(Query, :count)
    end
  end
end
