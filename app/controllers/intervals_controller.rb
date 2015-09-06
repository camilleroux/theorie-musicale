class IntervalsController < ApplicationController
  def index
    @intervals = Interval.all.sort
  end

  def show
    @interval = Interval.new_from_symbol(params[:id],true)
  end
end
