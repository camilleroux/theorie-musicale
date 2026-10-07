class ProgressionsController < ApplicationController
  def index
    @progressions = Progression.all
  end

  def show
    @progression = Progression.find(params[:id])
    @tonics = Key.primaries.sort_by(&:index)
    @tonic = @tonics.find { |key| key.to_param == params[:tonalite] } || Key.default
    @grid_chords = @progression.chords_in(@tonic) if @progression.bars
  end
end
