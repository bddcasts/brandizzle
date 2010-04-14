# == Schema Information
#
# Table name: logs
#
#  id                  :integer(4)      not null, primary key
#  loggable_id         :integer(4)      indexed => [loggable_type]
#  loggable_type       :string(255)     indexed => [loggable_id]
#  user_id             :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  loggable_attributes :text
#

require 'spec_helper'

describe Log do
  #columns
  should_have_column :loggable_type, :type => :string
  should_have_column :loggable_attributes, :type => :text
  
  #associations
  should_belong_to :user
  should_belong_to :loggable, :polymorphic => true
  
  describe "#set_loggable_attributes on before_create" do
    it "sets the brand_results attributes" do
      brand_result = Factory.create(:brand_result, :state => "follow_up")
      log = Log.create(:loggable => brand_result)
      log.loggable_attributes.should include({ "state" => "follow_up" })
    end
  end
end
