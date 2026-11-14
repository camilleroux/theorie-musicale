class CircleOfFifthsController < ApplicationController
  def show
    @positions = CircleOfFifths.positions
  end
end
