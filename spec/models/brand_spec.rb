require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brand do
  it { should have_column :name, :type => :string }
  it { should validate_presence_of :name }
  it { should have_many :searches }
end
