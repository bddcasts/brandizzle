require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchResult do
  #associations
  should_belong_to :result
  should_belong_to :query
end
