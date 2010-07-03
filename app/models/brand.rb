# == Schema Information
#
# Table name: brands
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  team_id    :integer(4)
#

class Brand < ActiveRecord::Base
  belongs_to :team
  
  has_many :brand_queries, :dependent => :delete_all
  has_many :queries, :through => :brand_queries
  
  has_many :brand_results
  has_many :results, :through => :brand_results
  
  validates_presence_of :name
  
  after_destroy :cleanup
  
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
  
  def to_s
    name
  end
  
  def brand_queries_count
    brand_queries.size
  end
  
  private
    def cleanup
      BrandResult.send_later(:cleanup_for_brand, id)
    end
end
