require 'test_helper'

class ChordSnippetTest < ActiveSupport::TestCase
  test 'chords in a key have the title and description they had until 2026-10-07' do
    chord = Chord.friendly.find('septieme-de-dominante').in_key_of('A')
    assert_equal 'Accord A (la) Septième de dominante', chord.seo_title
    assert_equal "L'accord Accord A Septième de dominante (A7) est composé des intervalles suivants : " \
      'Tierce majeure, Quinte juste et Septième mineure', chord.seo_description
  end

  test 'every chord in a key has its old title' do
    chord = Chord.friendly.find('mineur-7').in_key_of('A')
    assert_equal 'Accord A (la) Mineur 7', chord.seo_title
    assert_match(/\AL'accord Accord A Mineur 7 \(Am7\) est composé/, chord.seo_description)
  end

  test 'chord pages without a key keep their new title' do
    chord = Chord.friendly.find('septieme-de-dominante')
    assert_not chord.legacy_snippet?
    assert_match(/\AAccord septième de dominante \(C7/, chord.seo_title)
  end
end
