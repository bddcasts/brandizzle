# == Schema Information
#
# Table name: brand_results
#
#  id         :integer(4)      not null, primary key
#  brand_id   :integer(4)      indexed, indexed => [result_id]
#  result_id  :integer(4)      indexed, indexed => [brand_id]
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

class BrandResult < ActiveRecord::Base
  belongs_to :brand
  belongs_to :result
  
  def self.per_page
    per_page = Settings.pagination.results_per_page
  end

  [ 'normal', 'follow_up', 'done' ].each do |state|
    named_scope state, :conditions => {:state => state}
  end
  
  include AASM
  aasm_column :state
  
  aasm_initial_state :normal
  aasm_state :normal
  aasm_state :follow_up
  aasm_state :done
  
  aasm_event :follow_up do
    transitions :to => :follow_up, :from => [:normal]
  end
  
  aasm_event :finish do
    transitions :to => :done, :from => [:follow_up]
  end
  
  aasm_event :reject do
    transitions :to => :normal, :from => [:follow_up]
  end
end

