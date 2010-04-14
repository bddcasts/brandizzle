class BrandResultsController < ApplicationController
  before_filter :require_user
  before_filter :init_log_action, :only => [:update]
  
  def index
    @brands = current_team.brands
    @search = current_team.brand_results.search(params[:search] || {})
    
    @brand_results = @search.paginate(
      :page => params[:page],
      :include => [:result],
      :order => "results.created_at DESC")
  end

  def show
    @brand_result = current_team.brand_results.find(params[:id], :include => :result) if params[:id]
  end

  def update
    @brand_result = current_team.brand_results.find(params[:id]) if params[:id]
    send(action_type)
  end

  private    
    def action_type
      @action_type ||= case params[:action_type]
        when /follow_up/i then "follow_up"
        when /finish/i then "finish"
        when /reject/i then "reject"
      end
    end
    
    def follow_up
      @brand_result.follow_up!
      @service.update_brand_result(@brand_result, current_user)
      respond_to do |format|
        format.html {
          flash[:notice] = "Result marked for follow up!"
          redirect_to request.referer || brand_results_path
        }
        format.js { render }
      end
      
    end
    
    def finish
      @brand_result.finish!
      @service.update_brand_result(@brand_result, current_user)
      respond_to do |format|
        format.html {
          flash[:notice] = "Result marked as done!"
          redirect_to request.referer || brand_results_path
        }
        format.js { render }
      end
    end
    
    def reject
      @brand_result.reject!
      @service.update_brand_result(@brand_result, current_user)
      respond_to do |format|
        format.html {
          flash[:notice] = "Result rejected!"
          redirect_to request.referer || brand_results_path
        }
        format.js { render }
      end
    end
end