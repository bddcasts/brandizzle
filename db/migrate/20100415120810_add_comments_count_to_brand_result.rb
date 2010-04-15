class AddCommentsCountToBrandResult < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :comments_count, :integer, :default => 0
    
    BrandResult.reset_column_information
    BrandResult.all.each do |br|
      BrandResult.update_counters br.id, :comments_count => br.comments.length
    end
  end

  def self.down
    remove_column :brand_results, :comments_count
  end
end
