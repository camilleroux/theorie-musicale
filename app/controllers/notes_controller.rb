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

  def piano
    expires_in 1.month, public: true
    render plain: PianoDiagram.new([@key]).to_svg(title: helpers.piano_diagram_alt(@key)), content_type: 'image/svg+xml'
  end


  protected

  def find_key
    if params[:id]
      @key = Key[params[:id]]
    end
  end


end
