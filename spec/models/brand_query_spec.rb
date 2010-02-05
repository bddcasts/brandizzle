require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BrandQuery do
  #associations
  should_belong_to :brand
  should_belong_to :query
end
