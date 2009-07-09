require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchResult do
  it { should have_column(:body, :type => :text) }
  it { should have_column(:source, :url, :type => :string) }
  it { should belong_to(:search) }
end
