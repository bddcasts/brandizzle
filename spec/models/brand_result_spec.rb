# == Schema Information
#
# Table name: brand_results
#
#  id         :integer(4)      not null, primary key
#  brand_id   :integer(4)      indexed, indexed => [result_id]
#  result_id  :integer(4)      indexed, indexed => [brand_id]
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

require 'spec_helper'

describe BrandResult do
  #columns
  should_have_column :state, :type => :string
  
  #associations
  should_belong_to :brand
  should_belong_to :result
  
  describe "named scopes" do
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
end