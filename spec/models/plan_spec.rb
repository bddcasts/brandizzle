require 'spec_helper'

describe Plan do
  describe "settings" do
    before(:each) do
      Plan.namespace(rails_env)
      Plan.reload!
    end
    
    subject { Plan }
    
    context "in production" do
      let(:rails_env) { "production" }
      
      describe "standard" do
        subject { Plan.standard }
        
        its(:price)    { should == 29 }
        its(:members)  { should == 2 }
        its(:members)  { should == 2 }
        its(:searches) { should == 6 }
        its(:id)       { should == 'standard' }
      end
    end
  end
end
