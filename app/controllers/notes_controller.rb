class NotesController < ApplicationController
  before_action :find_key, :except => [:index]

  respond_to :html, :json

  def index
    @keys = Key.all.uniq{ |key| key.name }
    #respond_with @keys
  end

  def show
    #respond_with @key
  end

  def staff
    respond_with @chord do |format|
      format.html { render :layout => "staff" }
    end
  end


  protected

  def find_key
    if params[:id]
      @key = Key[params[:id]]
    end
  end


end
