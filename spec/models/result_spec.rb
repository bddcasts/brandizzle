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
    subject { Factory.build(:result, :source => source) }
    
    context "result's source is 'twitter'" do
      let(:source) { "twitter"}
      
      it "returns true" do
        should be_twitter
      end
    end

    context "result's source is 'blog'" do
      let(:source) { "twitter"}
      
      it "returns true" do
        should be_twitter
      end
    end

    context "result's source is nil" do
      let(:source) { "blog" }
      
      it "returns false" do
        should_not be_twitter
      end
    end
  end
  
  describe "#add_brand" do
    subject              { Factory.create(:result, :brands => [existing_brand]) }
    let(:existing_brand) { Factory.create(:brand) }
    let(:new_brand)      { Factory.create(:brand) }
    
    it "adds the brand to brands if it does not have it already" do
      subject.add_brand(new_brand)
      subject.brands.should include(new_brand)
    end
    
    it "does not add the brand if it has it already" do
      expect {
        subject.add_brand(existing_brand)
      }.to_not change(subject.brands, :count)
    end
  end
end

