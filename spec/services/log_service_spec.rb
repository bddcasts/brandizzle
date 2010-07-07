require 'spec_helper'

describe LogService do
  subject                 { LogService.new }
  let(:user)              { mock_model(User, :team => mock_model(Team)) }
  let(:logged_attributes) { mock("logged attributes") }

  describe "#update_brand_result" do
    let(:brand_result) { mock_model(BrandResult, :result => mock_model(Result)) }
    
    
    before(:each) do
      brand_result.stub(:logged_attributes => logged_attributes)
    end
    
    def call_update
      subject.updated_brand_result(brand_result, user, {"state" => "follow_up" })
    end
    
    it "gets the logged attributes from the brand result" do
      brand_result.should_receive(:logged_attributes).with({"state" => "follow_up" }).and_return(logged_attributes)
      call_update
    end
    
    it "logs the update of the brand result" do
      Log.
        should_receive(:create).
        with(hash_including(
          :loggable            => brand_result,
          :user                => user,
          :team                => user.team,
          :loggable_attributes => logged_attributes)
        )
      call_update
    end
  end
  
  describe "#create_comment" do
    let(:comment) { mock_model(Comment) }
    
    before(:each) do
      comment.stub(:logged_attributes => logged_attributes)
    end
    
    it "gets the logged attributes from the brand result" do
      comment.should_receive(:logged_attributes).and_return(logged_attributes)
      subject.created_comment(comment, user)
    end
    
    it "logs the creation of a new comment" do
      Log.should_receive(:create).with(hash_including(:loggable => comment, :user => user, :team => user.team))
      subject.created_comment(comment, user)
    end
  end
end
