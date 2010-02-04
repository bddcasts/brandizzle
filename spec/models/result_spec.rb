require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Result do
  it { should have_column(:body, :type => :text) }
  it { should have_column(:source, :url, :type => :string) }
  it { should have_column(:follow_up, :type => :boolean) }
  it { should have_index(:url).unique(true) }
  it { should belong_to(:search) }
  
  it {
    Factory.create(:result)
    should validate_uniqueness_of(:url)
  }

  describe "#toggle_follow_up" do
    it "should set follow_up to true if not set" do
      @result = Factory.create(:result)
      lambda {
        @result.toggle_follow_up
      }.should change(@result, :follow_up?)
      @result.follow_up?.should be_true
    end
    
    it "should set follow_up to false if set" do
      @result = Factory.create(:result, :follow_up => true)
      lambda {
        @result.toggle_follow_up
      }.should change(@result, :follow_up?)
      @result.follow_up?.should be_false
    end
  end

  it "does not create duplicate entries for same URL" do
    @result = Factory.create(:result)
    lambda {
      Factory.build(:result, :url => @result.url).save
    }.should_not change(Result, :count)
  end
end
