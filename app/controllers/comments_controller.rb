class CommentsController < ApplicationController
  before_filter :require_user, :find_brand_result
  
  def create
    @comment = @brand_result.comments.build((params[:comment] || {}).merge({:user => current_user, :team => current_user.team}))
    if @comment.save
      log.created_comment(@comment, current_user)
      flash[:notice] = "Comment posted"
      redirect_to brand_result_path(@brand_result)
    else
      @comments = Comment.find(:all, :conditions => { :brand_result_id => @brand_result }, :order => "created_at DESC")
      render :template => 'brand_results/show'
    end
  end
  
  private
    def find_brand_result
      @brand_result = current_team.brand_results.find(params[:brand_result_id]) if params[:brand_result_id]
    end
end