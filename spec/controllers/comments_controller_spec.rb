require 'spec_helper'

describe CommentsController do
  before(:each) do
    login_user
    @current_team = current_user.team
  end
  
  describe "handling POST create" do
    before(:each) do
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
    
    it "renders the show brand_result template on failure" do
      @comment.should_receive(:save).and_return(false)
      post :create, :brand_result_id => 42
      response.should render_template("brand_results/show")
    end
  end
end
