class Result < ActiveRecord::Base
  has_and_belongs_to_many :searches
  
  class << self
    # def find_by_url_or_create(url, search, options={})
    #   result = find(:first, :conditions => { :url => url }) || create(options.merge(:url => url))
    #   result.searches << search unless result.searches.include?(search)
    # end
  end

  def toggle_follow_up
    update_attribute(:follow_up, !follow_up?)
  end
end
