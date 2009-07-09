require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Search do
  it { should have_column :term, :type => :string }
  it { should validate_presence_of :term }
  it { should belong_to :brand }
  it { should have_many :results }
  
  describe "run against twitter" do
    before(:each) do
      @searches = (1..3).map { |i| Search.create(:term => "search-#{i}") }
      @twitter_searches = @searches.map { |s|
        mock("twitter search for #{s.term}", :fetch => mock('fetch-for-#{s.term}', :results => [
          {"created_at"=>"Thu, 02 Jul 2009 18:54:32 +0000",
            "profile_image_url"=>
            "http://s3.amazonaws.com/twitter_production/some/image.jpg",
            "from_user"=>"source_user",
            "to_user_id"=>nil,
            "text"=>"This is the message body for #{s.term}",
            "id"=>1234567,
            "from_user_id"=>987654,
            "iso_language_code"=>"en",
            "source"=>"&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;"}
        ]))
      }
      Search.stub!(:find).and_return(@searches)
      Twitter::Search.stub!(:new).and_return(@twitter_searches.first)
    end
    
    it "should find all the searches" do
      Search.should_receive(:find).with(:all).and_return(@searches)
      Search.run_against_twitter
    end
    
    it "runs a twitter search for each search" do
      @searches.each_with_index do |search, i|
        Twitter::Search.should_receive(:new).with(search.term).and_return(@twitter_searches[i])
        @twitter_searches[i].should_receive(:fetch).and_return(@twitter_searches[i].fetch)
      end
      Search.run_against_twitter
    end
    
    it "creates a new search result for each twitter result" do
      @searches.each_with_index do |search, i|
        Twitter::Search.should_receive(:new).with(search.term).and_return(@twitter_searches[i])
        result = @twitter_searches[i].fetch.results.first
        search.results.should_receive(:create).with(hash_including({
          :created_at => result["created_at"],
          :body => result["text"],
          :source => "twitter",
          :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"
        }))
      end
      Search.run_against_twitter
    end
  end
end