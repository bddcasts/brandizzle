class BrandResult < ActiveRecord::Base
  belongs_to :brand
  belongs_to :result
  
  def self.per_page
    per_page = Settings.pagination.results_per_page
  end
  
  def toggle_follow_up
    toggle!(:follow_up)
  end
end