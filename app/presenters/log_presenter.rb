class LogPresenter < Viewtastic::Base
  presents :log
  
  delegate :id, :loggable, :user, :loggable_type, :body,
           :to => :log
           
  delegate :current_user, :current_team,
          :to => :controller
  
  def dom_id
    log_dom_id
  end
  
  def log_type
    case loggable_type
    when "BrandResult"
      "Result"
    end
  end

end