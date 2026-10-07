class SearchController < ApplicationController
  def show
    @search = Search.new(params[:q])
    @results = @search.results
    redirect_to helpers.search_result_path(@results.first) if @results.one?
  end
end
