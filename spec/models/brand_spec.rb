# == Schema Information
#
# Table name: brands
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  team_id    :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brand do
  #columns
  should_have_column :name, :type => :string
  
  #associations
  should_have_many :brand_queries
  should_have_many :queries, :through => :brand_queries
  should_have_many :brand_results, :dependent => :destroy
  should_have_many :results, :through => :brand_results
  should_belong_to :team
  
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
  
  describe "#remove_query" do
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
    
    it "does nothing for a query not associated with the brand" do
      another_brand = Factory.create(:brand)
      foo_query = another_brand.add_query('foo')
      lambda {
        @brand.remove_query(foo_query)
      }.should_not change(Query, :count)
    end
  end
end
