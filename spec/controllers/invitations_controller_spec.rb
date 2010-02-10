require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController do
  before(:each) do
    login_user({}, {:invitation_limit => 1})
  end
  
  describe "handling GET new" do
    before(:each) do
      @invitation = mock_model(Invitation)
      current_user.stub_chain(:sent_invitations, :build).and_return(@invitation)
    end
    
    def do_get
      get :new
    end
    
    it "builds a new invitation for the current user and assigns it for the view" do
      current_user.sent_invitations.should_receive(:build).and_return(@invitation)
      do_get
      assigns[:invitation].should == @invitation
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
    
    it "sets the flash message and redirects if current user has no invitations to send" do
      current_user.should_receive(:invitation_limit).and_return(0)
      do_get
      flash[:notice].should_not be_nil
      response.should redirect_to(brand_results_path)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      @invitation = mock_model(Invitation, :errors => mock("errors", :null_object => true))
      current_user.stub_chain(:sent_invitations, :build).and_return(@invitation)
      
      @invitation.stub!(:deliver_invitation!)
    end
    
    def do_post_with_valid_attributes(options={})
      @invitation.should_receive(:save).and_return(true)
      post :create, :invitation => options
    end
    
    it "builds a new invitation from params for the current user and assigsn it for the view" do
      current_user.sent_invitations.
        should_receive(:build).
        with("recipient_email" => "stan@example.com").
        and_return(@invitation)
      do_post_with_valid_attributes(:recipient_email => "stan@example.com")
      assigns[:invitation].should == @invitation
    end
    
    it "delivers the invitation" do
      @invitation.should_receive(:deliver_invitation!)
      do_post_with_valid_attributes
    end
    
    it "sets the flash message and redirects to the results on success" do
      do_post_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(brand_results_path)
    end
    
    it "sets the flash error message and renders the new template on failure" do
      @invitation.should_receive(:save).and_return(false)
      post :create, :invitation => {}
      flash[:error].should_not be_nil
      response.should render_template(:new)
    end
  end
end
