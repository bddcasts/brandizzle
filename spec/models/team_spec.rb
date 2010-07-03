# == Schema Information
#
# Table name: teams
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Team do  
  #associations
  should_have_many :members, :class_name => "User"
  should_have_many :brands
  should_have_many :brand_results, :through => :brands
  should_belong_to :account
  should_have_many :logs, :through => :members
  
  describe "#total_search_terms" do
    let(:brands) { (1..3).map { |i| mock_model(Brand, :brand_queries_count => i) } }
    
    before(:each) do
      subject.stub(:brands => brands)
    end
    
    it "returns the sum of the number of queries for each brand" do
      subject.total_search_terms.should == 6
    end
  end
end
