class ModesController < ApplicationController
  before_action :set_body_class
  before_action :find_key
  before_action :find_scale
  before_action :find_mode
  before_action :find_scales

  respond_to :html, :json

  def index
    redirect_to scale
  end

  def show
    respond_with @scale, @mode
  end

  def piano
    expires_in 1.month, public: true
    render plain: PianoDiagram.new(@mode.keys).to_svg(title: helpers.piano_diagram_alt(@mode)), content_type: 'image/svg+xml'
  end


  protected

  def set_body_class
    @body_class = "scales"
  end

  def find_key
    if params[:key_id]
      @key = Key[params[:key_id]]
      @key = nil if @key.main?
    end
  end

  def find_scale
    @scale = Scale.friendly.find(params[:scale_id])
    @scale = @scale.in_key_of(@key) if @key
  end

  def find_mode
    @mode = @scale.modes.friendly.find(params[:id])
    @mode = @mode.in_key_of(@key) if @key
  end

  def find_scales
    @scales = Scale.includes :modes
  end
end
