# == Schema Information
#
# Table name: brand_results
#
#  id         :integer(4)      not null, primary key
#  brand_id   :integer(4)      indexed => [result_id], indexed
#  result_id  :integer(4)      indexed => [brand_id], indexed
#  created_at :datetime
#  updated_at :datetime
#  follow_up  :boolean(1)      default(FALSE)
#

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
