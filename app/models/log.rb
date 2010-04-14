class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :loggable, :polymorphic => true
  
  before_create :set_body
end