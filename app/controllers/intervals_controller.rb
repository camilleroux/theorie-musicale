class IntervalsController < ApplicationController
  before_filter :find_key, :only => [:show]

  def index
    @intervals = Interval.all.sort
  end

  def show
    @interval = Interval.new_from_symbol(params[:id],true)
    @interval = @interval.in_key_of(@key) if @key
  end

  protected

  def find_key
    if params[:key_id]
      @key = Key[params[:key_id]]
    end
  end
end
