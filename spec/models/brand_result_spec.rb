# == Schema Information
#
# Table name: brand_results
#
#  id                :integer(4)      not null, primary key
#  brand_id          :integer(4)      indexed, indexed => [result_id]
#  result_id         :integer(4)      indexed, indexed => [brand_id]
#  created_at        :datetime
#  updated_at        :datetime
#  state             :string(255)     indexed
#  comments_count    :integer(4)      default(0)
#  temperature       :integer(4)      indexed
#  read              :boolean(1)      default(FALSE), indexed
#  team_id           :integer(4)      indexed
#  result_created_at :datetime        indexed
#

require 'spec_helper'

describe BrandResult do
  #columns
  should_have_column :state, :type => :string
  should_have_column :temperature, :comments_count, :type => :integer
  should_have_column :read, :type => :boolean
  should_have_column :result_created_at, :type => :datetime
    
  #associations
  should_belong_to :brand
  should_belong_to :result
  should_belong_to :team
  should_have_many :comments, :dependent => :delete_all
  
  describe "named scopes" do
    describe "between_date" do
      it "fetches only brand results between specified dates" do
        expected = Factory.create(:brand_result, :result => Factory.create(:result, :created_at => 'Apr 9, 2010'))
        other = Factory.create(:brand_result, :result => Factory.create(:result, :created_at => 'Apr 2, 2010'))
        
        BrandResult.between_date("Apr 8, 2010 to Apr 10, 2010").should == [expected]
      end
    end
    
    describe "assm named scopes" do
      before(:each) do
        @normal_results = (1..2).map{ Factory.create(:brand_result) }
        @follow_up_results = (1..2).map { Factory.create(:follow_up_brand_result) }
        @done_results = (1..2).map { Factory.create(:done_brand_result) }
      end
      
      it "'normal' fetches only brand results with 'normal' state" do
        BrandResult.normal.should == @normal_results
      end
      
      it "'follow_up' fetches only brand results with 'follow_up' state" do
        BrandResult.follow_up.should == @follow_up_results
      end
      
      it "'done' fetches only brand results with 'done' state" do
        BrandResult.done.should == @done_results
      end
    end
    
    describe "#unread_before" do
      it "fetches unread brand_result whose result was created before the specified date" do
        expected = Factory.create(:brand_result, :result => Factory.create(:result, :created_at => 'Apr 19, 2010'))
        read = Factory.create(:read_brand_result, :result => Factory.create(:result, :created_at => 'Apr 2, 2010'))
        other = Factory.create(:brand_result, :result => Factory.create(:result, :created_at => 'Apr 25, 2010', :body => "test"))
        
        BrandResult.unread_before("Apr 21, 2010").should == [expected]
      end
    end
    
    context "read/unread named scopes" do
      before(:each) do
        @read_brand_result = Factory.create(:read_brand_result)
        @unread_brand_result = Factory.create(:brand_result)
      end
      
      it "#read fetches only read brand results" do
        BrandResult.read.should == [@read_brand_result]
      end
      
      it "#unread fetches only unread brand results" do
        BrandResult.unread.should == [@unread_brand_result]
      end
    end
  end
  
  describe "aasm_events" do
    subject { Factory.create(:brand_result, :state => state) }

    describe "#follow_up!" do
      let(:state) { "normal" }

      it "from 'normal': sets the brand_result on 'follow_up'" do
        subject.follow_up!
        should be_follow_up
      end
    end
    
    describe "#finish!" do
      let(:state) { "follow_up" }

      it "from 'follow_up': sets the brand_result on 'done'" do
        subject.finish!
        should be_done
      end
    end
    
    describe "#reject!" do
      let(:state) { "follow_up" }
      it "from 'follow_up': sets the brand_result on 'normal'" do
        subject.reject!
        should be_normal
      end
    end
  end
  
  describe "temperature" do
    subject { Factory.build(:brand_result, :temperature => temperature) }
    let(:temperature) { 0 }
    
    it "#warm_up! sets the brand_result temperature on 1" do
      subject.warm_up!
      subject.temperature.should == 1
    end
    
    it "#temperate! sets the brand result temperature on 0" do
      subject.temperate!
      subject.temperature.should == 0
    end
    
    it "#chill! sets the brand result temperature to -1" do
      subject.chill!
      subject.temperature.should == -1
    end
    
    describe "#neutral?" do
      context "temperature is set to 0" do
        it "returns true" do
          should be_neutral
        end
      end

      context "temperature is not set to 0" do
        let(:temperature) { 1 }

        it "returns false" do
          should_not be_neutral
        end
      end
    end

    describe "#negative?" do
      context "temperature is set to -1" do
        let(:temperature) { -1 }
        
        it "returns true" do
          should be_negative
        end
      end

      context "temperature is not set to -1" do
        it "returns false" do
          should_not be_negative
        end
      end
    end
  
    describe "#positive?" do
      context "temperature is set to 1" do
        let(:temperature) { 1 }
        
        it "returns true" do
          should be_positive
        end
      end
      
      context "temperature is not set to 1" do
        it "returns false" do
          should_not be_positive
        end
      end
    end
  end

  describe "#mark_as_read!" do
    subject { Factory.create(:brand_result) }

    it "sets read to true" do
      subject.mark_as_read!
      subject.should be_read
    end
  end
  
  describe ".cleanup_for_brand" do
    let(:brand_results) { (1..5).map { mock_model(BrandResult, :destroy => true) } }
    
    it "fetches all brand results in batches for the specified brand and destroys them" do
      BrandResult.
        should_receive(:find_in_batches).
        with(hash_including(:conditions => { :brand_id => 42 })).
        and_yield(brand_results)
      brand_results.each { |br| br.should_receive(:destroy) }
      BrandResult.cleanup_for_brand(42)
    end
  end
  
  describe "#logged_attributes" do
    subject { Factory.build(:brand_result, :result => result) }
    let(:result) { Factory.build(:result) }
    
    it "merges in 'body' and 'url' attributes of the associated result to the options argument" do
      subject.logged_attributes("temperature" => "positive").should == {
        "body"        => result.body,
        "url"         => result.url,
        "temperature" => "positive"
      }
    end
  end
end
