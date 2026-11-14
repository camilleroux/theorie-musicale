require 'test_helper'

class JazzVoicingTest < ActiveSupport::TestCase
  def voicings(slug, key)
    JazzVoicing.for(Chord.friendly.find(slug).in_key_of(Key[key])).to_h { |v| [v.name, [v.formula, v.notes]] }
  end

  test 'should build shells and drop 2 for seventh chords' do
    am7 = voicings('mineur-7', 'A')
    assert_equal ['1 – ♭3 – ♭7', %w[A/3 C/4 G/4]], am7['Shell']
    assert_equal ['1 – ♭7 – ♭3', %w[A/3 G/4 C/5]], am7['Shell renversé']
    assert_equal ['5 – 1 – ♭3 – ♭7', %w[E/3 A/3 C/4 G/4]], am7['Drop 2']
    assert_nil am7['Sans fondamentale (A)']
  end

  test 'should build rootless voicings for chords with a ninth' do
    cm9 = voicings('mineur-9', 'C')
    assert_equal ['♭3 – 5 – ♭7 – 9', %w[Eb/4 G/4 Bb/4 D/5]], cm9['Sans fondamentale (A)']
    assert_equal ['♭7 – 9 – ♭3 – 5', %w[Bb/3 D/4 Eb/4 G/4]], cm9['Sans fondamentale (B)']
    assert_equal ['3 – ♭7 – 9 – 13', %w[B/3 F/4 A/4 E/5]], voicings('treizieme', 'G')['Sans fondamentale']
  end

  test 'should write the octave of the letter' do
    assert_equal %w[B/2 D#/3 A#/3], voicings('majeur-7', 'B')['Shell'].last
  end

  test 'should not voice triads' do
    assert_empty JazzVoicing.for(Chord.friendly.find('majeur'))
  end
end
