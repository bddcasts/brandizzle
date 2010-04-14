require 'spec_helper'

describe LogActionService do
  before do
    @user = mock_model(User)
    @brand_result = mock_model(BrandResult, :result => mock_model(Result))

    @service = LogActionService.new
  end
  
  it "logs the update of the brand result" do
    Log.should_receive(:create).with(hash_including(:loggable => @brand_result, :user => @user))
    @service.update_brand_result(@brand_result, @user)
  end
end
