require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "handling SHOW" do
    def do_get(id)
      get :show, :id => id 
    end
    
    it "should render 404 for unknown templates" do
      do_get('all_your_pages_are_belong_to_us')
      response.should_not be_success
    end
    
    %w(about).each do |page|
      it "should render the template for the #{page} page" do
        do_get(page)
        response.should be_success
        response.should render_template("pages/show/#{page}")
      end
    end
  end
end
