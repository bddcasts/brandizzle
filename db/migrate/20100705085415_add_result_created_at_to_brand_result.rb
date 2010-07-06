class AddResultCreatedAtToBrandResult < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :result_created_at, :datetime
    add_index :brand_results, :result_created_at
    
    BrandResult.reset_column_information
    
    BrandResult.find_in_batches(:batch_size => 200) do |batch|
      batch.each do |br|
        br.update_attribute(:result_created_at, br.result.created_at)
      end
    end
  end

  def self.down
    remove_index :brand_results, :result_created_at
    remove_column :brand_results, :result_created_at
  end
end