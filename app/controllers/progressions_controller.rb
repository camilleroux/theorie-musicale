class ProgressionsController < ApplicationController
  def index
    @families = Progression.all.group_by(&:family).sort_by { |family, _| Progression::FAMILIES.index(family) }
  end

  def show
    @progression = Progression.find(params[:id])
    @tonics = Key.primaries.sort_by(&:index)
    @tonic = @tonics.find { |key| key.to_param == params[:tonalite] } || Key.default
    @grid_chords = @progression.chords_in(@tonic)
  end
end
