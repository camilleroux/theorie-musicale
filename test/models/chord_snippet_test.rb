require 'test_helper'

class ChordSnippetTest < ActiveSupport::TestCase
  test 'the chords of the A/B test have the title and description they had until 2026-10-07' do
    chord = Chord.friendly.find('septieme-de-dominante').in_key_of('A')
    assert_equal 'Accord A (la) Septième de dominante', chord.seo_title
    assert_equal "L'accord Accord A Septième de dominante (A7) est composé des intervalles suivants : " \
      'Tierce majeure, Quinte juste et Septième mineure', chord.seo_description
  end

  test 'the other chords keep the searched symbol in their title' do
    chord = Chord.friendly.find('mineur-7').in_key_of('A')
    assert_equal 'Accord Am7 (la mineur 7) : notes, guitare et piano', chord.seo_title
    assert_match(/\AAccord Am7 \(la mineur 7\) : notes A, C, E et G/, chord.seo_description)
  end

  test 'chord pages without a key are left out of the test' do
    assert_not Chord.friendly.find('septieme-de-dominante').legacy_snippet?
  end
end
