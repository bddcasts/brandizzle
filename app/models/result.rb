class Result < ActiveRecord::Base
  has_and_belongs_to_many :searches

  def toggle_follow_up
    update_attribute(:follow_up, !follow_up?)
  end
end
