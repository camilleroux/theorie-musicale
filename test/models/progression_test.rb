require 'test_helper'

class ProgressionTest < ActiveSupport::TestCase
  test 'reads a chart into chords and bars' do
    progression = Progression.find('blues-mineur')
    assert_equal %w[Im7 IVm7 ♭VI7 V7♭9 IIø], progression.steps.map(&:roman)
    assert_equal [[0], [0], [0], [0], [1], [1], [0], [0], [2], [3], [0], [4, 3]], progression.bars
  end

  test 'spells chords from the degrees of the key' do
    a = Key.primaries.find { |key| key.to_param == 'a' }
    assert_equal %w[A7 D7 D♯dim7 F♯7 Bm7 E7], Progression.find('blues-jazz').chords_in(a).map(&:display_symbol)
    assert_equal %w[Cm B♭ A♭ G], Progression.find('cadence-andalouse').chords_in(Key.default).map(&:display_symbol)
  end

  test 'shares a bar between its chords when played' do
    steps = Progression.find('anatole').playback(Key.default)
    assert_equal [2, 2, 2, 2], steps.map { |step| step[:beats] }
    assert_equal [0, 0, 1, 1], steps.map { |step| step[:bar] }
  end

  test 'has a family, a chart that parses and chords that exist for every progression' do
    Progression.all.each do |progression|
      assert_includes Progression::FAMILIES, progression.family
      assert progression.chords_in(Key.default).all?, progression.slug
    end
  end

  test 'rejects a chord it does not know' do
    assert_raises(KeyError) { Progression.step('IIm11') }
  end
end
