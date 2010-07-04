class BrandResultsController < ApplicationController
  before_filter :require_user
  before_filter :find_brand_result, :except => [:index, :mark_all_as_read]
  
  def index
    @brands = current_team.brands
    @search = current_team.brand_results.search(params[:search] || {})
        
    @brand_results = @search.paginate(
      :page          => params[:page],
      :include       => :result,
      :order         => "#{Result.table_name}.created_at DESC")
  end

  def show
    @comments = @brand_result.comments
    @comment = Comment.new
  end
  
  def follow_up
    @brand_result.follow_up!
    
    log.updated_brand_result(@brand_result, current_user, "state" => @brand_result.state)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked for follow up!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def finish
    @brand_result.finish!
    
    log.updated_brand_result(@brand_result, current_user, "state" => @brand_result.state)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as done!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def reject
    @brand_result.reject!
    
    log.updated_brand_result(@brand_result, current_user, "state" => @brand_result.state)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result rejected!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def positive
    @brand_result.warm_up!
    
    log.updated_brand_result(@brand_result, current_user, "temperature" => @brand_result.temperature)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as positive!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def neutral
    @brand_result.temperate!
    
    log.updated_brand_result(@brand_result, current_user, "temperature" => @brand_result.temperature)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as neutral!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def negative
    @brand_result.chill!
    
    log.updated_brand_result(@brand_result, current_user, "temperature" => @brand_result.temperature)
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as negative!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def mark_as_read
    @brand_result.mark_as_read!
    
    respond_to do |format|
      format.html {
        flash[:notice] = "Result marked as read!"
        redirect_to request.referer || brand_results_path
      }
      format.js { render "update.js.haml" }
    end
  end
  
  def mark_all_as_read
    @search = current_team.brand_results.unread_before(params[:before]).search(params[:search])
    @brand_results = @search.all
    
    BrandResult.update_all({:read => true}, {:id => @brand_results}) unless @brand_results.empty?

    redirect_to brand_results_path(:search => params[:search])
  end
  
  private    
    def find_brand_result
      @brand_result = current_team.brand_results.find(params[:id])
    end
end