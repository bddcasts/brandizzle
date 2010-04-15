require 'spec_helper'

describe BrandResultPresenter do
  describe "#delegates" do
    before(:each) do
      @brand_result = Factory.create(:brand_result)
      @presenter = BrandResultPresenter.new(:brand_result => @brand_result)
    end
    
    [:id, :brand, :result, :follow_up?, :comments].each do |message|
      it "delegates ##{message} to brand_result" do
        @brand_result.should_receive(message)
        @presenter.send(message)
      end
    end
    
    [:current_user, :current_team].each do |message|
      it "delegates ##{message} to controller" do
        @presenter.controller.should_receive(message)
        @presenter.send(message)
      end
    end
  end
  
  describe "#status" do
    it "returns empty string when brand_result state is 'normal'" do
      brand_result = Factory.create(:brand_result, :state => "normal")
      presenter = BrandResultPresenter.new(:brand_result => brand_result)
      presenter.status.should == ""
    end

    it "returns 'follow up' when brand_result state is 'follow_up'" do
      brand_result = Factory.create(:brand_result, :state => "follow_up")
      presenter = BrandResultPresenter.new(:brand_result => brand_result)
      presenter.status.should match(/follow up/)
    end
    
    it "returns 'done' when brand_result state is 'done'" do
      brand_result = Factory.create(:brand_result, :state => "done")
      presenter = BrandResultPresenter.new(:brand_result => brand_result)
      presenter.status.should match(/done/)
    end
  end
end
