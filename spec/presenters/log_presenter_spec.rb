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
end
