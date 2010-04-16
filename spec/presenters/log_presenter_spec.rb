require 'spec_helper'

describe LogPresenter do
  describe "#delegates" do
    before(:each) do
      @log = Factory.create(:log, :loggable => Factory.create(:brand_result))
      @presenter = LogPresenter.new(:log => @log)
    end
    
    [:id, :loggable, :user, :loggable_type, :loggable_attributes, :created_at].each do |message|
      it "delegates ##{message} to log" do
        @log.should_receive(message)
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
  
  # describe "#log_type" do
  #   it "returns 'Positive' if loggable is brand_result and connotation is not 0" do
  #     brand_result = Factory.create(:brand_result, :connotation => 1)
  #     log = Factory.create(:log, :loggable => brand_result)
  #     presenter = LogPresenter.new(:log => log)
  #     presenter.log_type.should match(/Positive/)
  #   end
  #   
  #   it "returns 'Follow up' if loggable is brand_result and connotation is 0" do
  #     brand_result = Factory.create(:follow_up_brand_result)
  #     log = Factory.create(:log, :loggable => brand_result)
  #     presenter = LogPresenter.new(:log => log)
  #     presenter.log_type.should match(/Follow up/)
  #   end
  #   
  #   it "returns 'Comment' if loggable is comment" do
  #     log = Factory.create(:comment_log)
  #     presenter = LogPresenter.new(:log => log)
  #     presenter.log_type.should match(/Comment/)
  #   end
  # end
  # 
  # describe "#comment_log_description" do
  #   before(:each) do
  #     login_user({}, {:login => "stan"})
  #     brand_result = Factory.create(:brand_result)
  #     @comment = Factory.create(:comment, :brand_result => brand_result)
  #     
  #     log = Factory.create(:log, :loggable => @comment, :user => current_user)
  # 
  #     @presenter = LogPresenter.new(:log => log)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :brand_result_path => "/brand_results/#{brand_result.id}"
  #     )
  #   end
  #   
  #   it "returns the comment log description" do
  #     @presenter.comment_log_description(@comment).should match(/stan/)
  #     @presenter.comment_log_description(@comment).should match(/commented/)
  #     @presenter.comment_log_description(@comment).should match(/result/)
  #   end
  # end
  # 
  # describe "#brand_result_state_log_description" do
  #   before(:each) do
  #     login_user({}, {:login => "stan"})
  #     @brand_result = Factory.create(:brand_result)
  #     
  #     log = Factory.create(:log, :loggable => @brand_result, :user => current_user)
  # 
  #     @presenter = LogPresenter.new(:log => log)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :polymorphic_path => "/brand_results/#{@brand_result.id}"
  #     )
  #   end
  #   
  #   it "returns the brand_result state log description" do
  #     @presenter.brand_result_state_log_description(@brand_result, "follow_up").should match(/stan/)
  #     @presenter.brand_result_state_log_description(@brand_result, "follow_up").should match(/a result/)
  #     @presenter.brand_result_state_log_description(@brand_result, "follow_up").should match(/as follow up/)
  #   end
  # end
  # 
  # describe "#brand_result_connotation_log_description" do
  #   before(:each) do
  #     login_user({}, {:login => "stan"})
  #     @brand_result = Factory.create(:brand_result, :connotation => 1)
  #     
  #     log = Factory.create(:log, :loggable => @brand_result, :user => current_user)
  # 
  #     @presenter = LogPresenter.new(:log => log)
  #     @presenter.controller = mock("MockController", 
  #       :current_user => current_user,
  #       :polymorphic_path => "/brand_results/#{@brand_result.id}"
  #     )
  #   end
  #   
  #   it "returns the brand_result connotation log description" do
  #     @presenter.brand_result_connotation_log_description(@brand_result, 1).should match(/stan/)
  #     @presenter.brand_result_connotation_log_description(@brand_result, 1).should match(/a result/)
  #     @presenter.brand_result_connotation_log_description(@brand_result, 1).should match(/as positive/)
  #   end
  # end
end
