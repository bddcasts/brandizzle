# == Schema Information
#
# Table name: brand_results
#
#  id             :integer(4)      not null, primary key
#  brand_id       :integer(4)      indexed, indexed => [result_id]
#  result_id      :integer(4)      indexed, indexed => [brand_id]
#  created_at     :datetime
#  updated_at     :datetime
#  state          :string(255)     indexed
#  comments_count :integer(4)      default(0)
#

class BrandResult < ActiveRecord::Base
  belongs_to :brand
  belongs_to :result
  has_many :comments
  
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
  
  def attributes_to_serialize
    attributes.reject { |k, v| ['id', 'brand_id', 'result_id', 'updated_at', 'created_at'].include?(k) }
  end
end
