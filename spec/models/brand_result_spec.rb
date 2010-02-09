require 'spec_helper'

describe BrandResult do
  #columns
  should_have_column :follow_up, :type => :boolean
  
  #associations
  should_belong_to :brand
  should_belong_to :result
  
  describe "#toggle_follow_up" do
    it "should set follow_up to true if not set" do
      @brand_result = Factory.create(:brand_result)
      lambda {
        @brand_result.toggle_follow_up
      }.should change(@brand_result, :follow_up?)
      @brand_result.follow_up?.should be_true
    end
    
    it "should set follow_up to false if set" do
      @brand_result = Factory.create(:brand_result, :follow_up => true)
      lambda {
        @brand_result.toggle_follow_up
      }.should change(@brand_result, :follow_up?)
      @brand_result.follow_up?.should be_false
    end
  end
  
end