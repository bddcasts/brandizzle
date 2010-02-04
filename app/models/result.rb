class Result < ActiveRecord::Base
  belongs_to :search
  validates_uniqueness_of :url
  
  class << self
    def per_page
      15
    end
  end

  def toggle_follow_up
    update_attribute(:follow_up, !follow_up?)
  end
end
