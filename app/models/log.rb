class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :loggable, :polymorphic => true
  
  before_create :set_body
  
  def self.per_page
    per_page = Settings.pagination.results_per_page
  end
  
  private
    def set_body
      case loggable_type
      when "BrandResult"
        self.body = "Marked a result as #{loggable.state}"
      end
    end
end