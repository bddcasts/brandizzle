class ChangeFollowUpForAasm < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :state, :string
    
    BrandResult.reset_column_information
    
    BrandResult.all.each do |br|
      if br.follow_up?
        br.state = "follow_up"
      else
        br.state = "normal"
      end
      br.save
    end
    
    remove_column :brand_results, :follow_up
    
    add_index :brand_results, :state
  end

  def self.down
    remove_index :brand_results, :state
    add_column :brand_results, :follow_up, :boolean,  :default => false    
    remove_column :brand_results, :state
  end
end
