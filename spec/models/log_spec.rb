require 'spec_helper'

describe Log do
  #columns
  should_have_column :loggable_type, :type => :string
  should_have_column :body, :type => :text
  
  #associations
  should_belong_to :user
  should_belong_to :loggable, :polymorphic => true
end
