class ChordsController < ApplicationController
  before_action :find_key
  before_action :find_chord, :except => [:index]
  before_action :find_chord_qualities

  respond_to :html, :json

  def index
    respond_with @chord_qualities do |format|
      format.json { render :json => @chord_qualities.to_json(:include => [:chords]) }
    end
  end

  def show
    respond_with @chord
  end

  def guitar
    voicing = GuitarVoicing.for(@chord)[params[:position].to_i - 1]
    raise ActionController::RoutingError, 'Not Found' unless voicing

    expires_in 1.month, public: true
    render plain: voicing.to_svg(title: helpers.guitar_diagram_alt(@chord, params[:position].to_i, voicing)), content_type: 'image/svg+xml'
  end

  def piano
    expires_in 1.month, public: true
    render plain: PianoDiagram.new(@chord.keys).to_svg(title: helpers.piano_diagram_alt(@chord)), content_type: 'image/svg+xml'
  end


  protected

  def find_key
    if params[:key_id]
      @key = Key[params[:key_id]]
      @key = nil if @key.main?
    end
  end

  def find_chord
    @chord = Chord.friendly.find(params[:id])
    @chord = @chord.in_key_of(@key) if @key
  end

  def find_chord_qualities
    @chord_qualities = ChordQuality.includes(:chords)
  end
end
