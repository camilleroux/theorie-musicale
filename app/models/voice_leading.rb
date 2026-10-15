# Voices a run of chords as MIDI notes the way a jazz pianist would: the root
# in the bass, the other notes (all of them for a triad) in close position in
# the right hand, with the inversions chosen so the voices move as little as
# possible from one chord to the next. A simpler take on Jazzity's VoiceLeader
# (https://github.com/eigenben/jazzity, MIT License), without voicing families.
#
#   VoiceLeading.new(progression.chords_in(Key.default)).voiced # => [[38, 60, 65, 69], ...]
class VoiceLeading
  # Right hand from Ab3 to F5, centred on F4, as in Jazzity
  LOW, HIGH, CENTRE = 56, 77, 65
  # Bass from E2 to Eb3
  BASS_LOW = 40
  # Cost of the top voice moving further than a whole step, per semitone
  TOP_LEAP_WEIGHT = 1.0
  # Cost of a voicing's average pitch straying from the centre, per semitone
  DRIFT_WEIGHT = 0.5

  def initialize(chords)
    @chords = chords
  end

  # The notes of each chord, bass first
  def voiced
    @chords.zip(best_path).map do |chord, upper|
      [BASS_LOW + (chord.keys.first.index - BASS_LOW) % 12, *upper]
    end
  end

  private

  # Every inversion of the right-hand notes at every octave that fits the register
  def candidates(chord)
    classes = chord.keys.map(&:index)
    classes = classes.drop(1) if classes.size > 3

    classes.size.times.flat_map do |inversion|
      rotated = classes.rotate(inversion)
      (LOW..HIGH).select { |midi| midi % 12 == rotated.first }.map do |bottom|
        rotated.drop(1).reduce([bottom]) { |notes, pc| notes << notes.last + (pc - notes.last - 1) % 12 + 1 }
      end
    end.select { |notes| notes.last <= HIGH }
  end

  def cost(notes)
    (notes.sum / notes.size.to_f - CENTRE).abs * DRIFT_WEIGHT
  end

  # Semitones the voices move, note for note, plus the top voice's leaps
  def transition_cost(from, to)
    movement = if from.size == to.size
      from.zip(to).sum { |a, b| (a - b).abs }
    else
      nearest = ->(notes, others) { notes.sum { |n| others.map { |o| (n - o).abs }.min } }
      (nearest.call(from, to) + nearest.call(to, from)) / 2.0
    end
    movement + [(from.last - to.last).abs - 2, 0].max * TOP_LEAP_WEIGHT
  end

  # The candidates with the lowest total cost over the whole run (Viterbi)
  def best_path
    options = @chords.map { |chord| candidates(chord) }
    return [] if options.empty?

    totals = options.first.map { |notes| cost(notes) }
    back = []
    options.each_cons(2) do |previous, current|
      links = current.map do |notes|
        best = previous.each_index.min_by { |i| totals[i] + transition_cost(previous[i], notes) }
        [best, totals[best] + transition_cost(previous[best], notes) + cost(notes)]
      end
      back << links.map(&:first)
      totals = links.map(&:last)
    end

    index = totals.each_index.min_by { |i| totals[i] }
    back.reverse.reduce([index]) { |path, links| [links[path.first], *path] }.each_with_index.map { |i, n| options[n][i] }
  end
end
