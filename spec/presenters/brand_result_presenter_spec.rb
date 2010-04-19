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
  
  # describe "#action_links" do
  #   before(:each) do
  #     login_user
  #     @brand_result = Factory.create(:brand_result, :result => Factory.create(:result, :url => "http://twitter.com/statusses/12345"))
  #     @presenter = BrandResultPresenter.new(:brand_result => @brand_result)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :brand_result_path => "/brand_results/#{@brand_result.id}",
  #       :follow_up_brand_result_path => "/brand_results/#{@brand_result.id}/follow_up",
  #       :finish_brand_result_path => "/brand_results/#{@brand_result.id}/finish",
  #       :reject_brand_result_path => "/brand_results/#{@brand_result.id}/reject"
  #     )  
  #   end
  #   
  #   it "returns the url of the result" do
  #     @presenter.action_links[0].should match /http\:\/\/twitter.com\/statusses\/12345/
  #   end
  #   
  #   it "returns a link to view the brand result" do
  #     @presenter.action_links[1].should == "<a href=\"/brand_results/#{@brand_result.id}\">View</a>"
  #   end
  #   
  #   it "returns a 'follow_up' link for the brand_result if state is normal" do
  #     @presenter.action_links[2].should match(/Follow up/)
  #   end
  #   
  #   it "returns a 'done' link for the brand_result if state is follow_up" do
  #     @brand_result.follow_up!
  #     @presenter.action_links[2].should match(/Done/)
  #   end
  #   
  #   it "returns a 'reject' link for the brand_result if state is follow_up" do
  #     @brand_result.follow_up!
  #     @presenter.action_links[3].should match(/Reject/)
  #   end
  # end
  # 
  # describe "#temperature_links" do
  #   before(:each) do
  #     login_user
  #     @brand_result = Factory.create(:brand_result)
  #     @presenter = BrandResultPresenter.new(:brand_result => @brand_result)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :positive_brand_result_path => "/brand_results/#{@brand_result.id}/positive",
  #       :neutral_brand_result_path => "/brand_results/#{@brand_result.id}/neutral",
  #       :negative_brand_result_path => "/brand_results/#{@brand_result.id}/negative"
  #     )  
  #   end
  #   
  #   it "returns a 'warm_up' link for the brand_result if brand_result is not positive" do
  #     @presenter.temperature_links[0].should match(/<a.*>(\+)<\/a>/)
  #   end
  #   
  #   it "returns a 'positive' flag for the brand_result if brand_result is positive" do
  #     @brand_result.warm_up!
  #     @presenter.temperature_links[0].should match(/<span.*>(\+)<\/span>/)
  #   end
  #   
  #   it "returns a 'temperate' link for the brand_result if brand_result is not neutral" do
  #     @presenter.temperature_links[1].should match(/<a.*>(\=)<\/a>/)
  #   end
  #   
  #   it "returns a 'neutral' flag for the brand_result if brand_result is neutral" do
  #     @brand_result.temperate!
  #     @presenter.temperature_links[1].should match(/<span.*>(\=)<\/span>/)
  #   end
  #   
  #   it "returns a 'chill' link for the brand_result if brand_result is not negative" do
  #     @presenter.temperature_links[2].should match(/<a.*>(\-)<\/a>/)
  #   end
  #   
  #   it "returns a 'negative' flag for the brand_result if brand_result is negative" do
  #     @brand_result.chill!
  #     @presenter.temperature_links[2].should match(/<span.*>(\-)<\/span>/)
  #   end
  # end
end
