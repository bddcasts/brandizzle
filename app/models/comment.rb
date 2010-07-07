# == Schema Information
#
# Table name: comments
#
#  id              :integer(4)      not null, primary key
#  brand_result_id :integer(4)      indexed
#  user_id         :integer(4)      indexed
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#  team_id         :integer(4)      indexed
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :brand_result, :counter_cache => true
  belongs_to :team
  
  validates_presence_of :content
  
  named_scope :latest, 
    :include => :user,
    :order => "#{Comment.table_name}.created_at DESC",
    :limit => Settings.dashboard.latest_comments_number
  
  def logged_attributes
    brand_result.logged_attributes
  end
end
