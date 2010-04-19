class BrandResultsController < ApplicationController
  before_filter :require_user
  before_filter :find_brand_result, :except => [:index]
  
  def index
    @brands = current_team.brands
    @search = current_team.brand_results.search(params[:search] || {})
    
    @brand_results = @search.paginate(
      :page => params[:page],
      :include => [:result],
      :order => "results.created_at DESC")
  end

  def show
    @comments = @brand_result.comments.find(:all, :order => "created_at DESC")
    @comment = Comment.new
  end

  def update
    send(action_type)
  end
  
  def positive
    @brand_result = current_team.brand_results.find(params[:id])
    @brand_result.warm_up!
    
    log.updated_brand_result(@brand_result, current_user)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as positive!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def neutral
    @brand_result = current_team.brand_results.find(params[:id])
    @brand_result.temperate!
    
    log.updated_brand_result(@brand_result, current_user)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as neutral!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def negative
    @brand_result = current_team.brand_results.find(params[:id])
    @brand_result.chill!
    
    log.updated_brand_result(@brand_result, current_user)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as negative!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  private    
    def find_brand_result
      @brand_result = current_team.brand_results.find(params[:id])
    end
    
    def action_type
      @action_type ||= case params[:action_type]
        when /follow_up/i then "follow_up"
        when /finish/i    then "finish"
        when /reject/i    then "reject"
      end
    end
    
    def follow_up
      @brand_result.follow_up!
      log.updated_brand_result(@brand_result, current_user)
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
      log.updated_brand_result(@brand_result, current_user)
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
      log.updated_brand_result(@brand_result, current_user)
      respond_to do |format|
        format.html {
          flash[:notice] = "Result rejected!"
          redirect_to request.referer || brand_results_path
        }
        format.js { render }
      end
    end
end