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