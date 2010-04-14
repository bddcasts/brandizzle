# == Schema Information
#
# Table name: logs
#
#  id                  :integer(4)      not null, primary key
#  loggable_id         :integer(4)      indexed => [loggable_type]
#  loggable_type       :string(255)     indexed => [loggable_id]
#  user_id             :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  loggable_attributes :text
#

class Log < ActiveRecord::Base
  serialize :loggable_attributes
  
  belongs_to :user
  belongs_to :loggable, :polymorphic => true
  
  before_create :set_loggable_attributes
    
  def self.per_page
    per_page = Settings.pagination.results_per_page
  end
  
  def set_loggable_attributes
    self.loggable_attributes = loggable.attributes_to_serialize
  end
end
