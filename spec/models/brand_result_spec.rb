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
#  connotation    :integer(4)      indexed
#

require 'spec_helper'

describe BrandResult do
  #columns
  should_have_column :state, :type => :string
  should_have_column :connotation, :comments_count, :type => :integer
  
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
  
  describe "attributes_for_log" do
    it "includes the brand_results state in attributes to save in the log" do
      brand_result = Factory.create(:brand_result, :state => "done")
      brand_result.attributes_for_log.should include({"state" => "done"})
    end
    
    it "includes the brand_results connotation in attributes to save in the log" do
      brand_result = Factory.create(:brand_result, :connotation => 1)
      brand_result.attributes_for_log.should include({"connotation" => 1})
    end
    
    ['id', 'brand_id', 'result_id', 'updated_at', 'created_at', 'comments_count'].each do |att|
      it "does not include #{att} on the attributes to save in the log" do
        brand_result = Factory.create(:brand_result)
        brand_result.attributes_for_log.should_not include({att => brand_result.send(att)})
      end
    end
  end
  
  describe "#make_positive!" do
    it "increments the brand result connotation" do
      brand_result = Factory.create(:brand_result)
      brand_result.make_positive!
      brand_result.connotation.should == 1
    end
  end
  
  describe "#make_negative!" do
    it "decrements the brand result connotation" do
      brand_result = Factory.create(:brand_result)
      brand_result.make_negative!
      brand_result.connotation.should == -1
    end
  end

  describe "#positive?" do
    it "returns true if connotation is set to 1" do
      brand_result = Factory.build(:positive_brand_result)
      brand_result.should be_positive
    end
    
    it "returns false if connotation is not set to 1" do
      brand_result = Factory.build(:brand_result)
      brand_result.should_not be_positive
    end
  end

  describe "#negative?" do
    it "returns true if connotation is set to -1" do
      brand_result = Factory.build(:negative_brand_result)
      brand_result.should be_negative
    end
    
    it "returns false if connotation is not set to -1" do
      brand_result = Factory.build(:brand_result)
      brand_result.should_not be_negative
    end
  end
end
