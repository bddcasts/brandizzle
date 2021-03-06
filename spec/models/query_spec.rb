# == Schema Information
#
# Table name: queries
#
#  id         :integer(4)      not null, primary key
#  term       :string(255)
#  latest_id  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Query do
  #columns
  should_have_column :term, :latest_id, :type => :string
  
  #validations
  should_validate_presence_of :term
  
  #associations
  should_have_many :brand_queries
  should_have_many :brands, :through => :brand_queries
  
  should_have_many :search_results
  
  describe ".run" do
    let(:queries) { (1..3).map { mock_model(Query) } }
    
    before(:each) do
      queries.each do |query|
        query.stub!(:run)
      end
      Query.stub!(:find_in_batches).and_yield(queries)
    end
    
    it "should find all the queries" do
      Query.should_receive(:find_in_batches).with(:batch_size => 200).and_yield(queries)
      Query.run
    end
    
    it "runs each query" do
      queries.each do |query|
        query.should_receive(:run)
      end
      Query.run
    end
  end
  
  describe "#run" do
    before(:each) do
      subject.stub(:send_later)
    end
    
    it "sends later #run_against_twitter" do
      subject.should_receive(:send_later).with(:run_against_twitter)
      subject.run
    end
    
    it "sends later #run_against_blog_search" do
      subject.should_receive(:send_later).with(:run_against_blog_search)
      subject.run
    end
  end
  
  describe "#run_against_twitter" do
    before(:each) do
      @query = Factory.create(:query)
      @twitter_search = mock("twitter search", :fetch => mock('fetch', :results => [
        {"created_at"=>"Thu, 02 Jul 2009 18:54:32 +0000",
          "profile_image_url"=>
          "http://s3.amazonaws.com/twitter_production/some/image.jpg",
          "from_user"=>"source_user",
          "to_user_id"=>nil,
          "text"=>"This is the message body for #{@query.term}",
          "id"=>1231117,
          "from_user_id"=>987654,
          "iso_language_code"=>"en",
          "source"=>"&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;"},
        {"created_at"=>"Thu, 02 Jul 2009 13:54:32 +0000",
          "profile_image_url"=>
          "http://s3.amazonaws.com/twitter_production/some/image.jpg",
          "from_user"=>"source_user",
          "to_user_id"=>nil,
          "text"=>"This is the message body for #{@query.term}",
          "id"=>1234567,
          "from_user_id"=>987654,
          "iso_language_code"=>"en",
          "source"=>"&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;"}
      ]))
      Twitter::Search.stub!(:new).and_return(@twitter_search)
      
      @returned_result = Factory.create(:result)
    end

    it "creates a new twitter search and fetches the results since latest id" do
      query = Factory.create(:since_query, :latest_id => "123456789")
      since_search = mock("since", :fetch => mock("fetch", :results => []))
      twitter_search = mock("twitter search")
      Twitter::Search.should_receive(:new).with(query.term).and_return(twitter_search)
      twitter_search.should_receive(:since).with('123456789').and_return(since_search)
      query.run_against_twitter
    end

    it "creates a new twitter search and fetches all results if this is the first search" do
      Twitter::Search.should_receive(:new).with(@query.term).and_return(@twitter_search)
      @twitter_search.should_receive(:fetch).and_return(@twitter_search.fetch)
      @query.run_against_twitter
    end

    it "finds or creates a new result for each twitter result" do
      @twitter_search.fetch.results.each do |result|
        Result.
          should_receive(:find_or_create_by_url).
          with(hash_including({
            :created_at => result["created_at"],
            :body => @query.highlight_term_in_twitter_result(result["text"]),
            :source => "twitter",
            :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"
          })).
          and_return(@returned_result)
      end
      @query.run_against_twitter
    end
    
    it "links the returned (found or newly created) result to the current query" do
      Result.stub!(:find_or_create_by_url).and_return(@returned_result)
      @query.run_against_twitter
      @query.results.should include(@returned_result)
    end

    it "saves the message id for the latest twitter result" do
      lambda {
        @query.run_against_twitter
        @query.reload
      }.should change(@query, :latest_id)
      @query.latest_id.should == "1234567"
    end

    it "only updates latest_id if we have results" do
      since_search = mock("since", :fetch => mock("fetch", :results => []))
      @twitter_search.stub!(:since).and_return(since_search)
      @query.latest_id = '1234'
      @query.save
      lambda {
        @query.run_against_twitter
        @query.reload
      }.should_not change(@query, :latest_id)
    end
  end

  describe "#parse_response" do
    before(:each) do
      @json_string = open(File.dirname(__FILE__) + "/../fixtures/bdd.json").read
      @json = JSON.parse(@json_string)
      @query = Factory.create(:query)
      @returned_result = Factory.create(:result)
    end
    
    it "creates a new result for each result" do
      @json["responseData"]["results"].each do |r|
        Result.
          should_receive(:find_or_create_by_url).
          with(hash_including({
            :source => 'blog',
            :body => r["content"],
            :created_at => r["publishedDate"],
            :url => r["postUrl"]
          })
        ).and_return(@returned_result)
      end
      @query.parse_response(@json_string, 33)
    end
    
    it "links the returned (found or newly created) to the current query" do
      Result.stub!(:find_or_create_by_url).and_return(@returned_result)
      @query.parse_response(@json_string, 33)
      @query.results.should include(@returned_result)
    end
    
    it "returns an array with all the start indices to fetch if start == 0" do
      @query.parse_response(@json_string, 0).should == [8, 16, 24, 32, 40, 48, 56]
    end
    
    it "returns an empty array if start >= 0" do
      @query.parse_response(@json_string, 1).should be_empty
    end
  end

  describe "#run_against_blog_search" do
    before(:each) do
      @response_file = open(File.dirname(__FILE__) + "/../fixtures/bdd.json")
      @response = open(File.dirname(__FILE__) + "/../fixtures/bdd.json").read
      @json_response = JSON.parse(@response)
      @query = Factory.create(:query, :term => "bdd")
      def @query.open(*args)
        File.open(File.dirname(__FILE__) + "/../fixtures/bdd.json")
      end
    end
    
    it "properly escapes the query terms for calling open on" do
      query = Factory.create(:query, :term => "this is a multi word term")
      @response_without_pages = open(File.dirname(__FILE__) + "/../fixtures/bdd_without_pages.json")
      query.should_receive(:open).with("http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=this%20is%20a%20multi%20word%20term&rsz=large&start=0").and_return(@response_without_pages)
      query.run_against_blog_search
    end
    
    it "fetches the results from blog search" do
      JSON.stub!(:parse).and_return(@json_response)
      0.upto(7) do |i|
        @query.should_receive(:open).with("http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=bdd&rsz=large&start=#{i*8}").and_return(@response_file)
      end
      @query.run_against_blog_search
    end
    
    it "parses results for each page" do
      0.upto(7) do |page|
        returns = page == 0 ? [8, 16, 24, 32, 40, 48, 56] : []
        @query.should_receive(:parse_response).with(@response, page*8).and_return(returns)
      end
      @query.run_against_blog_search
    end
  end

  describe "#link_brand_results" do
    let(:results) { (1..3).map { mock_model(Result) } }
    let(:brands)  { (1..3).map { mock_model(Brand) } }
    
    before(:each) do
      subject.stub(:link_results)
      subject.stub(:brands => brands)
      Result.stub(:find => results)
    end
    
    def call_link
      subject.link_brand_results([41, 42, 43])
    end
    
    it "finds the results specified by the IDs" do
      Result.should_receive(:find).with([41, 42, 43]).and_return(results)
      call_link
    end
    
    it "links the results found to every brand associated with self" do
      brands.each do |brand|
        subject.should_receive(:link_results).with(results, brand)
      end
      call_link
    end
  end
  
  describe "#link_results" do
    let(:results) { (1..3).map { mock_model(Result) } }
    let(:brand)   { mock_model(Brand) }
    
    it "links every result in the specified batch with every brand associated with self" do
      results.each do |result|
        result.should_receive(:add_brand).with(brand)
      end
      
      subject.link_results(results, brand)
    end
  end
  
  describe "#link_all_results_to_brand" do
    let(:brand)   { mock_model(Brand) }
    let(:results) { mock("query results") }
    let(:batch)   { (1..3).map { mock_model(Result) } }
    
    before(:each) do
      subject.stub(:results => results)
    end
    
    it "finds all the associated results in batches and links them to the brand" do
      results.should_receive(:find_in_batches).and_yield(batch)
      subject.should_receive(:link_results).with(batch, brand)
      subject.link_all_results_to_brand(brand)
    end
  end
  
  describe "#highlight_term_in_twitter_result" do
    it "highlights the query term in a twitter result" do
      query = Factory.create(:query, :term => "test")
      query.highlight_term_in_twitter_result("this is a test").should == "this is a <b>test</b>"
    end
  end
end
