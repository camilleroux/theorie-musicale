require 'test_helper'

class CircleOfFifthsTest < ActiveSupport::TestCase
  test 'should spell the chords of each key from its scale degrees' do
    positions = CircleOfFifths.positions
    b = positions.find { |position| position.tonic.name == 'B' }
    assert_equal %w[Bmaj7 C♯m7 D♯m7 Emaj7 F♯7 G♯m7 A♯m7♭5], b.diatonic_chords.map { |_, chord| chord.display_symbol }
    assert_equal %w[D♯m7♭5 G♯7 C♯m6], positions.find { |position| position.tonic.name == 'E' }.minor_ii_v_i.map(&:display_symbol)
    assert_equal '4 bémols (si♭, mi♭, la♭ et ré♭)', positions.find { |position| position.tonic.name == 'A♭' }.signature_text
  end
end
