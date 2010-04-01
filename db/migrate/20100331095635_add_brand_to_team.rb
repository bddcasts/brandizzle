class AddBrandToTeam < ActiveRecord::Migration
  def self.up
    add_column :brands, :team_id, :integer
    
    Brand.all.each do |brand|
      user = User.exists?(brand.user_id) && User.find(brand.user_id)      
      if user
        brand.team = user.team
        brand.save(false)
      end
    end
    
    remove_column :brands, :user_id
  end

  def self.down
    add_column :brands, :user_id, :integer
    remove_column :brands, :team_id
  end
end
