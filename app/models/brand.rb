class Brand < ActiveRecord::Base
  validates_presence_of :name
  has_and_belongs_to_many :searches
  belongs_to :user
  
  def add_search(term)
    search = Search.find_or_create_by_term(term)
    searches << search
    search
  end
  
  def remove_search(search)
    if searches.include?(search)
      searches.delete(search)
      search.destroy if search.brands.count == 0
    end
  end
end
