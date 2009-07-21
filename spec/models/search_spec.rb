require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Search do
  # it { should have_column :term, :latest_id, :type => :string }
  # it { should validate_presence_of :term }
  # it { should belong_to :brand }
  # it { should have_many :results }
  
  describe "run" do
    before(:each) do
      @searches = (1..3).map { |i| Search.create(:term => "search-#{i}") }
      @searches.each do |search|
        search.stub!(:run_against_twitter)
        search.stub!(:run_against_blog_search)
      end
      Search.stub!(:find).and_return(@searches)
    end
    
    it "should find all the searches" do
      Search.should_receive(:find).with(:all).and_return(@searches)
      Search.run
    end
    
    it "runs a twitter search for each search" do
      @searches.each_with_index do |search, i|
        search.should_receive(:run_against_twitter)
        search.should_receive(:run_against_blog_search)
      end
      Search.run
    end
  end
  
  describe "#run_against_twitter (instance method)" do
    before(:each) do
      @search = Search.create(:term => "foo")
      @twitter_search = mock("twitter search", :fetch => mock('fetch', :results => [
        {"created_at"=>"Thu, 02 Jul 2009 18:54:32 +0000",
          "profile_image_url"=>
          "http://s3.amazonaws.com/twitter_production/some/image.jpg",
          "from_user"=>"source_user",
          "to_user_id"=>nil,
          "text"=>"This is the message body for #{@search.term}",
          "id"=>1231117,
          "from_user_id"=>987654,
          "iso_language_code"=>"en",
          "source"=>"&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;"},
        {"created_at"=>"Thu, 02 Jul 2009 13:54:32 +0000",
          "profile_image_url"=>
          "http://s3.amazonaws.com/twitter_production/some/image.jpg",
          "from_user"=>"source_user",
          "to_user_id"=>nil,
          "text"=>"This is the message body for #{@search.term}",
          "id"=>1234567,
          "from_user_id"=>987654,
          "iso_language_code"=>"en",
          "source"=>"&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;"}
      ]))
      Twitter::Search.stub!(:new).and_return(@twitter_search)
    end

    it "creates a new twitter search and fetches the results since latest id" do
      search = Search.create!(:term => 'bar', :latest_id => '123456789')
      since_search = mock("since", :fetch => mock("fetch", :results => []))
      twitter_search = mock("twitter search")
      Twitter::Search.should_receive(:new).with(search.term).and_return(twitter_search)
      twitter_search.should_receive(:since).with('123456789').and_return(since_search)
      search.run_against_twitter
    end

    it "creates a new twitter search and fetches all results if this is the first search" do
      Twitter::Search.should_receive(:new).with(@search.term).and_return(@twitter_search)
      @twitter_search.should_receive(:fetch).and_return(@twitter_search.fetch)
      @search.run_against_twitter
    end

    it "creates a new search result for each twitter result" do
      @twitter_search.fetch.results.each do |result|
        @search.results.should_receive(:create).with(hash_including({
          :created_at => result["created_at"],
          :body => result["text"],
          :source => "twitter",
          :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"
        }))        
      end
      @search.run_against_twitter
    end

    it "saves the message id for the latest twitter result" do
      lambda {
        @search.run_against_twitter
        @search.reload
      }.should change(@search, :latest_id)
      @search.latest_id.should == "1234567"
    end

    it "only updates latest_id if we have results" do
      since_search = mock("since", :fetch => mock("fetch", :results => []))
      @twitter_search.stub!(:since).and_return(since_search)
      @search.latest_id = '1234'
      @search.save
      lambda {
        @search.run_against_twitter
        @search.reload
      }.should_not change(@search, :latest_id)
    end
  end

  describe "#parse_response" do
    before(:each) do
      @json_string = open(File.dirname(__FILE__) + "/../fixtures/bdd.json").read
      @json = JSON.parse(@json_string)
      @search = Search.create(:term => "bdd")
    end
    
    it "creates a new search result for each result" do
      @json["responseData"]["results"].each do |r|
        @search.results.should_receive(:create).with(
          :source => 'blog',
          :body => r["content"],
          :url => r["postUrl"],
          :created_at => r["publishedDate"]
        )
      end
      @search.parse_response(@json_string, 33)
    end
    
    it "returns an array with all the start indices to fetch if start == 0" do
      @search.parse_response(@json_string, 0).should == [8, 16, 24, 32, 40, 48, 56]
    end
    
    it "returns an empty array if start >= 0" do
      @search.parse_response(@json_string, 1).should be_empty
    end
    
  end

  describe "#run_against_blog_search" do
    before(:each) do
      @response_file = open(File.dirname(__FILE__) + "/../fixtures/bdd.json")
      @response = open(File.dirname(__FILE__) + "/../fixtures/bdd.json").read
      @json_response = JSON.parse(@response)
      @search = Search.create(:term => "bdd")
      # @search.stub!(:open).and_return(@response_file)
      def @search.open(*args)
        File.open(File.dirname(__FILE__) + "/../fixtures/bdd.json")
      end
    end
    
    it "fetches the results from blog search" do
      JSON.stub!(:parse).and_return(@json_response)
      0.upto(7) do |i|
        @search.should_receive(:open).with("http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=bdd&rsz=large&start=#{i*8}").and_return(@response_file)
      end
      @search.run_against_blog_search
    end
    
    it "parses search results for each page" do
      0.upto(7) do |page|
        returns = page == 0 ? [8, 16, 24, 32, 40, 48, 56] : []
        @search.should_receive(:parse_response).with(@response, page*8).and_return(returns)
      end
      @search.run_against_blog_search
    end

  end
end