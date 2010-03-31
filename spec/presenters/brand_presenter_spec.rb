require 'spec_helper'

describe BrandPresenter do
  describe "#delegates" do
    before(:each) do
      @brand = Factory.create(:brand)
      @presenter = BrandPresenter.new(:brand => @brand)
    end
    
    [:id, :name, :queries].each do |message|
      it "delegates ##{message} to brand" do
        @brand.should_receive(message)
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
