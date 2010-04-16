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
  #       :brand_result_path => "/brand_results/#{@brand_result.id}"
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
  # describe "#connotation_links" do
  #   before(:each) do
  #     login_user
  #     @brand_result = Factory.create(:brand_result)
  #     @presenter = BrandResultPresenter.new(:brand_result => @brand_result)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :brand_result_path => "/brand_results/#{@brand_result.id}"
  #     )  
  #   end
  #   
  #   it "returns a 'make_positive' link for the brand_result if connotation is neutral" do
  #     @presenter.connotation_links[0].should match(/\+/)
  #   end
  #   
  #   it "returns a 'make_negative' link for the brand_result if connotation is neutral" do
  #     @presenter.connotation_links[1].should match(/\-/)
  #   end
  #   
  #   it "returns 'Positive' if brand_result connotation is 1" do
  #     @brand_result.make_positive!
  #     @presenter.connotation_links[0].should match(/Positive/)
  #   end
  #   
  #   it "returns 'Negative' if brand_result connotation is -1" do
  #     @brand_result.make_negative!
  #     @presenter.connotation_links[0].should match(/Negative/)
  #   end
  # end
end
