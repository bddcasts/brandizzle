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
  
  # describe "#action_links" do
  #   before(:each) do
  #     login_user
  #     brand = Factory.create(:brand)
  #     @presenter = BrandPresenter.new(:brand => brand)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :edit_brand_path => "brands/#{brand.id}/edit",
  #       :brand_path => "brands/#{brand.id}", :null_object => true)
  #       
  #   end
  #   
  #   it "returns empty array if current user is not account holder" do
  #     @presenter.action_links.should be_empty
  #   end
  #   
  #   it "returns a manage link (edit_brand_path) for the brand if user is account holder" do
  #     current_user.account = Factory.create(:account)
  #     current_user.save
  #     
  #     @presenter.action_links[0].should match(/Manage/)
  #   end
  #   
  #   it "returns a remove link (brand_path) for the brand if user is account holder" do
  #     current_user.account = Factory.create(:account)
  #     current_user.save
  #     
  #     @presenter.action_links[1].should match(/Remove/)
  #   end
  # end
end
