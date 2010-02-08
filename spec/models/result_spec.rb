require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Result do
  #columns
  should_have_column :body, :type => :text
  should_have_column :source, :url, :type => :string
  
  it { should have_index(:url).unique(true) }
  
  #associations
  should_have_many :search_results
  should_have_many :queries, :through => :search_results
  should_have_many :brand_results
  should_have_many :brands, :through => :brand_results  
end
