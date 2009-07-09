class Search < ActiveRecord::Base
  validates_presence_of :term
  belongs_to :brand
end
