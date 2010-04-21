# == Schema Information
#
# Table name: results
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  source     :string(255)
#  url        :string(255)     indexed
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Result do
  #columns
  should_have_column :body, :type => :text
  should_have_column :source, :url, :type => :string
  
  it { should have_index(:url).unique(true) }
  
  #associations
  should_have_many :search_results
  should_have_many :queries, :through => :search_results
  should_have_many :brand_results
  should_have_many :brands, :through => :brand_results  
  
  describe "#twitter?" do
    it "returns true if result's source is 'twitter'" do
      result = Factory.build(:twitter_result)
      result.should be_twitter
    end

    it "returns false if result's source is not 'twitter'" do
      result = Factory.build(:result)
      result.should_not be_twitter
    end
  end
end

