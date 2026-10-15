require 'test_helper'

class VoiceLeadingTest < ActiveSupport::TestCase
  test 'voices a ii-V-I with the root in the bass and guide tones moving by step' do
    chords = Progression.find('ii-v-i-majeur').chords_in(Key.default)
    # D3 | C4 F4 A4, G2 | D4 F4 B4, C3 | E4 G4 B4
    assert_equal [[50, 60, 65, 69], [43, 62, 65, 71], [48, 64, 67, 71]], VoiceLeading.new(chords).voiced
  end

  test 'keeps every note of a triad in the right hand' do
    chords = Progression.find('i-v-vi-iv').chords_in(Key.default)
    assert_equal [3], VoiceLeading.new(chords).voiced.map { |notes| notes.size - 1 }.uniq
  end

  test 'follows the bars of a grid, with the same voicing for a repeated chord' do
    steps = Progression.find('blues').playback(Key.default)
    assert_equal 12, steps.size
    assert_equal steps[0][:notes], steps[2][:notes]
    assert_equal [0, 1, 2], steps.first(3).map { |step| step[:bar] }
  end

  test 'repeats the last chord of a ii-V-I for its second bar' do
    steps = Progression.find('ii-v-i-majeur').playback(Key.default)
    assert_equal [4, 4, 4, 4], steps.map { |step| step[:beats] }
    assert_equal [0, 1, 2, 2], steps.map { |step| step[:step] }
  end
end
