class EarTrainingController < ApplicationController
  def show
    @intervals = IntervalSong.symbols.map { |symbol| Interval.new_from_symbol(symbol, true) }
  end
end
