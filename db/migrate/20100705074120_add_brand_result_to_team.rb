class AddBrandResultToTeam < ActiveRecord::Migration
  def self.up
    add_column :brand_results, :team_id, :integer
    add_index :brand_results, :team_id
    
    BrandResult.reset_column_information
        
    Brand.all.each do |b|
      b.brand_results.update_all("team_id" => b.team_id)
    end
  end

  def self.down
    remove_index :brand_results, :team_id
    remove_column :brand_results, :team_id
  end
end