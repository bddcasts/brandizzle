class Result < ActiveRecord::Base
  has_many :search_results
  has_many :queries, :through => :search_results

  def toggle_follow_up
    update_attribute(:follow_up, !follow_up?)
  end
end
