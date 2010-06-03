require 'spec_helper'

describe CommentsController do
  describe "access_control" do
    [:create].each do |action|
      it "requires user to be logged in for action #{action}" do
        get action
        flash[:notice].should == "You must be logged in to access this page"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "account holder" do
      before(:each) do
        login_unsubscribed_account_holder
      end
      
      [:create].each do |action|
        it "requires a subscribed account #{action}" do
          get action
          flash[:notice].should == "You must be subscribed in order to keep using our services!"
          response.should redirect_to(account_path)
        end
      end
    end

    context "team member" do
      before(:each) do
        login_unsubscribed_user
        user_session.stub(:destroy)
      end
      
      [:create].each do |action|
        it "requires a subscribed account #{action}" do
          get action
          flash[:notice].should == "The subscription for this account has expired. Please inform your account holder."
          response.should redirect_to(new_user_session_path)
        end
      end
    end
  end
  
  describe "actions" do
    before(:each) do
      login_user
      @current_team = current_user.team
    end
  
    describe "handling POST create" do
      before(:each) do
        @log = LogService.new
        LogService.stub!(:new).and_return(@log)
        @log.stub!(:created_comment)
        Log.stub!(:create)
      
        @brand_result = Factory.create(:brand_result)
        @current_team.stub_chain(:brand_results, :find).and_return(@brand_result)
      
        @comment = mock_model(Comment)
        @brand_result.stub_chain(:comments, :build).and_return(@comment)
      end
    
      def do_post_with_valid_attributes(options={})
        @comment.should_receive(:save).and_return(true)
        post :create, { :brand_result_id => 42 }.merge(:comment => options)
      end
    
      it "finds the specified brand result and assigns it for the view" do
        @current_team.brand_results.
          should_receive(:find).
          with("42").
          and_return(@brand_result)
        do_post_with_valid_attributes
        assigns[:brand_result].should == @brand_result
      end
    
      it "builds the comment for the specified brand_result" do
        @brand_result.comments.
          should_receive(:build).
          with(hash_including({:content => "Lorem ipsum"})).
          and_return(@comment)
        do_post_with_valid_attributes(:content => "Lorem ipsum")
        assigns[:comment].should == @comment
      end
    
      it "sets the flash and redirect to the brand_result show page on success" do
        do_post_with_valid_attributes
        flash[:notice].should_not be_nil
        response.should redirect_to(brand_result_path(@brand_result))
      end
    
      it "sends a message to the log action service to create a log for the comment on success" do
        @log.should_receive(:created_comment).with(@comment, current_user)
        do_post_with_valid_attributes
      end
    
      it "renders the show brand_result template on failure" do
        @comment.should_receive(:save).and_return(false)
        post :create, :brand_result_id => 42
        response.should render_template("brand_results/show")
      end
    end
  end
end
