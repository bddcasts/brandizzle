class Brand < ActiveRecord::Base
  belongs_to :user
  
  has_many :brand_queries
  has_many :queries, :through => :brand_queries
  
  validates_presence_of :name
  
  def add_query(term)
    query = Query.find_or_create_by_term(term)
    queries << query
    query
  end
  
  def remove_query(query)
    if queries.include?(query)
      queries.delete(query)
      query.destroy if query.brands.count == 0
    end
  end
end
