class Brand < ActiveRecord::Base
  validates_presence_of :name
  has_many :searches
end
