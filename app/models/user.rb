class User < ActiveRecord::Base
  acts_as_authentic
  
  def to_s
    login
  end
end
