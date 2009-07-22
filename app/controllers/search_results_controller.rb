class SearchResultsController < ApplicationController
  before_filter :find_search_result  
  
  def follow_up
    @search_result.toggle_follow_up
    redirect_to request.referer || root_path
  end

  private
    def find_search_result
      @search_result = SearchResult.find(params[:id]) if params[:id]
    end
end