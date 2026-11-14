# Major key page (/tonalite/d): key signature, relative minor, scale, chords of each degree, progressions.
# Keys without a key signature (G♯ major, double sharps) redirect to their enharmonic key.
class KeysController < ApplicationController
  def show
    @key = key_from_param!(params[:id])
    @position = CircleOfFifths.position_for(@key)
    return if @position

    enharmonic = Key.primaries.find { |key| key.index == @key.index }
    redirect_to key_url(enharmonic), status: :moved_permanently
  end
end
