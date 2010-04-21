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
#  temperature    :integer(4)      indexed
#  read           :boolean(1)      default(FALSE), indexed
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
  
  named_scope :unread_before, lambda { |before| 
    {:joins => :result,
    :conditions => ["#{BrandResult.table_name}.read = ? AND #{Result.table_name}.created_at <= ?", false, before.to_time]}
  }
  
  named_scope :read, :conditions => { :read => true }
  named_scope :unread, :conditions => { :read => false }
  
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
  
  def warm_up!
    self.temperature = 1
    save!
  end
  
  def temperate!
    self.temperature = 0
    save!
  end
  
  def chill!
    self.temperature = -1
    save!
  end
  
  def positive?
    temperature == 1
  end
  
  def neutral?
    temperature == 0
  end
  
  def negative?
    temperature == -1
  end
  
  def mark_as_read!
    self.read = true
    save!
  end
end
