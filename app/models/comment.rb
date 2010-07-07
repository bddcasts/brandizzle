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
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :brand_result, :counter_cache => true
  
  validates_presence_of :content
  
  named_scope :latest, :order => "#{Comment.table_name}.created_at DESC", :limit => 10
  
  def logged_attributes
    brand_result.logged_attributes
  end
end
