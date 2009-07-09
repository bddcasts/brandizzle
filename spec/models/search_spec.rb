require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Search do
  it { should have_column :term, :type => :string }
  it { should validate_presence_of :term }
  it { should belong_to :brand }
end