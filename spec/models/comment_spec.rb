# == Schema Information
#
# Table name: comments
#
#  id              :integer(4)      not null, primary key
#  brand_result_id :integer(4)      indexed
#  user_id         :integer(4)      indexed
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#  team_id         :integer(4)      indexed
#

require 'spec_helper'

describe Comment do
  #columns
  should_have_column :content, :type => :text
  
  #associations
  should_belong_to :user
  should_belong_to :brand_result
  should_belong_to :team
  
  #validations
  should_validate_presence_of :content

  describe "named scopes" do
    describe "latest" do
      it "fetches latest comments" do
        @comments = (1..Settings.dashboard.latest_comments_number+1).map{ Factory.create(:comment) }
        Comment.latest.length.should == Settings.dashboard.latest_comments_number
      end
    end
  end
  
  describe "#logged_attributes" do
    subject { Factory.build(:comment) }
    
    it "forwards to the associated brand result" do
      subject.brand_result.should_receive(:logged_attributes)
      subject.logged_attributes
    end
  end
end
