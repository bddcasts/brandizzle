require 'spec_helper'

describe LogActionService do
  before do
    @user = mock_model(User)
    @service = LogActionService.new
  end

  describe "#update_brand_result" do
    before(:each) do
      @brand_result = mock_model(BrandResult, :result => mock_model(Result))
    end
    
    it "logs the update of the brand result" do
      Log.should_receive(:create).with(hash_including(:loggable => @brand_result, :user => @user))
      @service.update_brand_result(@brand_result, @user)
    end
  end
  
  describe "#create_comment" do
    before(:each) do
      @comment = mock_model(Comment)
    end
    
    it "logs the creation of a new comment" do
      Log.should_receive(:create).with(hash_including(:loggable => @comment, :user => @user))
      @service.create_comment(@comment, @user)
    end
  end
end
