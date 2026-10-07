class ProgressionsController < ApplicationController
  def index
    @progressions = Progression.all
  end

  def show
    @progression = Progression.find(params[:id])
    @tonics = Key.primaries.sort_by(&:index)
  end
end
