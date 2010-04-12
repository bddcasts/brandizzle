# == Schema Information
#
# Table name: brand_results
#
#  id         :integer(4)      not null, primary key
#  brand_id   :integer(4)      indexed => [result_id], indexed
#  result_id  :integer(4)      indexed => [brand_id], indexed
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)     indexed
#

class BrandResult < ActiveRecord::Base
  belongs_to :brand
  belongs_to :result
  
  def self.per_page
    per_page = Settings.pagination.results_per_page
  end

  named_scope :between_date, lambda { |date_range|
    from = date_range.split(" to ").first.to_time.beginning_of_day
    to = date_range.split(" to ").last.to_time.end_of_day
    
    {:joins => :result,
    :conditions => ["#{Result.table_name}.created_at >= ? AND #{Result.table_name}.created_at <= ?", from, to]}
  }

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

