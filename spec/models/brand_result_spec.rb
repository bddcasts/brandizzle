# == Schema Information
#
# Table name: brand_results
#
#  id             :integer(4)      not null, primary key
#  brand_id       :integer(4)      indexed, indexed => [result_id]
#  result_id      :integer(4)      indexed, indexed => [brand_id]
#  created_at     :datetime
#  updated_at     :datetime
#  state          :string(255)     indexed
#  comments_count :integer(4)      default(0)
#  temperature    :integer(4)      indexed
#

require 'spec_helper'

describe BrandResult do
  #columns
  should_have_column :state, :type => :string
  should_have_column :temperature, :comments_count, :type => :integer
    
  #associations
  should_belong_to :brand
  should_belong_to :result
  should_have_many :comments
  
  describe "named scopes" do
    describe "between_date" do      
      it "fetches only brand results between specified dates" do
        expected = Factory.create(:brand_result, :result => Factory.create(:result, :created_at => 'Apr 9, 2010'))
        other = Factory.create(:brand_result, :result => Factory.create(:result, :created_at => 'Apr 2, 2010'))
        
        BrandResult.between_date("Apr 8, 2010 to Apr 10, 2010").should == [expected]
      end
    end
    
    describe "assm named scopes" do
      before(:each) do
        @normal_results = (1..2).map{ Factory.create(:brand_result) }
        @follow_up_results = (1..2).map { Factory.create(:follow_up_brand_result) }
        @done_results = (1..2).map { Factory.create(:done_brand_result) }
      end
      
      it "'normal' fetches only brand results with 'normal' state" do
        BrandResult.normal.should == @normal_results
      end
      
      it "'follow_up' fetches only brand results with 'follow_up' state" do
        BrandResult.follow_up.should == @follow_up_results
      end
      
      it "'done' fetches only brand results with 'done' state" do
        BrandResult.done.should == @done_results
      end
    end
  end
  
  describe "aasm_events" do
    describe "#follow_up!" do
      it "from 'normal': sets the brand_result on 'follow_up'" do
        brand_result = Factory.create(:brand_result)
        brand_result.follow_up!
        brand_result.should be_follow_up
      end
    end
    
    describe "#finish!" do
      it "from 'follow_up': sets the brand_result on 'done'" do
        brand_result = Factory.create(:follow_up_brand_result)
        brand_result.finish!
        brand_result.should be_done
      end
    end
    
    describe "#reject!" do
      it "from 'follow_up': sets the brand_result on 'normal'" do
        brand_result = Factory.create(:follow_up_brand_result)
        brand_result.reject!
        brand_result.should be_normal
      end
    end
  end
  
  describe "temperature" do
    let(:brand_result) { Factory.create(:brand_result) }  
    
    context "#warm_up!" do
      it "sets the brand_result temperature on 1" do
        brand_result.warm_up!
        brand_result.temperature.should == 1
      end
    end
    
    context "#temperate!" do
      it "sets the brand result temperature on 0" do
        brand_result.temperate!
        brand_result.temperature.should == 0
      end
    end
    
    context "#chill!" do
      it "sets the brand result temperature to -1" do
        brand_result = Factory.create(:brand_result)
        brand_result.chill!
        brand_result.temperature.should == -1
      end
    end
  end
    
  describe "#neutral?" do
    it "returns true if temperature is set to 0" do
      brand_result = Factory.build(:neutral_brand_result)
      brand_result.should be_neutral
    end
    
    it "returns false if temperature is not set to 0" do
      brand_result = Factory.build(:brand_result)
      brand_result.should_not be_neutral
    end
  end
  
  describe "#negative?" do
    it "returns true if temperature is set to -1" do
      brand_result = Factory.build(:negative_brand_result)
      brand_result.should be_negative
    end
    
    it "returns false if temperature is not set to -1" do
      brand_result = Factory.build(:brand_result)
      brand_result.should_not be_negative
    end
  end
end
