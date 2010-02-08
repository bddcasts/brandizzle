class BrandResult < ActiveRecord::Base
  belongs_to :brand
  belongs_to :result
  
  def toggle_follow_up
    toggle!(:follow_up)
  end
end