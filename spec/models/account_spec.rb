require 'spec_helper'

describe Account do
  #associations
  should_belong_to :holder, :class_name => "User", :foreign_key => "user_id"
end
