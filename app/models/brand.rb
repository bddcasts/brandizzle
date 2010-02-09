class Brand < ActiveRecord::Base
  belongs_to :user
  
  has_many :brand_queries
  has_many :queries, :through => :brand_queries
  
  has_many :brand_results, :dependent => :destroy
  has_many :results, :through => :brand_results
  
  validates_presence_of :name
  
  def add_query(term)
    query = Query.find_or_create_by_term(term)
    queries << query
    query.send_later(:link_brand_results, query.results.map(&:id))
    query
  end
  
  def remove_query(query)
    if queries.include?(query)
      queries.delete(query)
    end
  end
end
