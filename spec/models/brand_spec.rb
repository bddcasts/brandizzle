# == Schema Information
#
# Table name: brands
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  team_id    :integer(4)      indexed
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brand do
  #columns
  should_have_column :name, :type => :string
  
  #associations
  should_have_many :brand_queries, :dependent => :delete_all
  should_have_many :queries, :through => :brand_queries
  should_have_many :brand_results
  should_have_many :results, :through => :brand_results
  should_belong_to :team
  
  #validations
  should_validate_presence_of :name

  subject { Factory.create(:brand) }
  
  describe "#add_query" do
    it "creates a new query associated if it does not exist yet" do
      expect {
        subject.add_query('foo')
      }.to change(Query, :count)
      
      subject.queries.map(&:term).should include('foo')
    end
    
    it "for an existing query it associates it with the brand and does not create a new one" do
      query = Factory.create(:query, :term => 'foo')
      
      expect {
        subject.add_query('foo')
      }.to_not change(Query, :count)
      
      subject.queries.map(&:term).should include('foo')
    end
    
    it "tells the query to link all its results to the brand" do
      query = mock_model(Query)
      Query.should_receive(:find_or_create_by_term).with("foo").and_return(query)
      query.should_receive(:send_later).with(:link_all_results_to_brand, subject)
      subject.add_query('foo')
    end
    
    it "returns the query" do
      query = subject.add_query('foo')
      query.term.should == 'foo'
    end
  end
  
  describe "#remove_query" do
    let(:bar_query) { subject.add_query('bar') }
    
    it "removes the query from the brand" do
      subject.remove_query(bar_query)
      subject.queries.map(&:term).should_not include('bar')
    end
    
    it "does not destroy the query if it is associated to any brand" do
      another_brand = Factory.create(:brand)
      another_brand.add_query('bar')
      
      expect {
        subject.remove_query(bar_query)
      }.to_not change(Query, :count)
    end
    
    it "does nothing for a query not associated with the brand" do
      another_brand = Factory.create(:brand)
      foo_query = another_brand.add_query('foo')
      
      expect {
        subject.remove_query(foo_query)
      }.to_not change(Query, :count)
    end
  end

  describe "#to_s" do
    subject { Factory.create(:brand, :name => "foo")}
    
    it "returns the name of the brand" do
      subject.to_s.should == "foo"
    end
  end

  describe "cleaning up on destroy" do
    it "calls cleanup its brand results" do
      BrandResult.should_receive(:send_later).with(:cleanup_for_brand, subject.id)
      subject.destroy
    end
  end
end
