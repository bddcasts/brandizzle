require 'spec_helper'

describe BrandResultPresenter do
  describe "#delegates" do
    before(:each) do
      @brand_result = Factory.create(:brand_result)
      @presenter = BrandResultPresenter.new(:brand_result => @brand_result)
    end
    
    [:id, :brand, :result, :follow_up?].each do |message|
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
end
