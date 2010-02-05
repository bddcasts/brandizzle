class ResultsController < ApplicationController
  before_filter :find_result
  
  def follow_up
    @result.toggle_follow_up
    redirect_to request.referer || brands_path
  end

  private
    def find_result
      @result = Result.find(params[:id]) if params[:id]
    end
end