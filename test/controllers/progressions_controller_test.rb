require 'test_helper'

class ProgressionsControllerTest < ActionDispatch::IntegrationTest
  test 'should list progressions' do
    get '/progressions'
    assert_response :success
    assert_select 'h3 a', Progression.all.size
    assert_select 'h2', Progression::FAMILIES.size
  end

  test 'should show a progression in every key with correct spelling' do
    get '/progressions/ii-v-i-majeur'
    assert_response :success
    assert_select 'tbody tr', 12
    # In B the II is C♯m7, not D♭m7
    assert_select 'a[href=?]', '/tonalite/cd/accords/mineur-7', text: 'C♯m7'
    # C chords link to the canonical key-less page
    assert_select 'a[href=?]', '/accords/majeur-7', text: 'Cmaj7'
  end

  test 'should not find an unknown progression' do
    get '/progressions/nope'
    assert_response :not_found
  end

  test 'should show the blues grid in the chosen key' do
    get '/progressions/blues', params: { tonalite: 'bb' }
    assert_select 'h2', 'Grille en si bémol'
    assert_select 'link[rel=canonical][href$=?]', '/progressions/blues'
  end

  test 'should keep the titles of the first progressions' do
    get '/progressions/ii-v-i-majeur'
    assert_select 'title', 'Progression II-V-I majeur : accords et tonalités | Théorie musicale'
    get '/progressions/blues'
    assert_select 'title', 'Grille de blues 12 mesures : accords et tonalités | Théorie musicale'
  end

  test 'should show every progression with its grid' do
    Progression.all.each do |progression|
      get progression_path(progression)
      assert_response :success
      assert_select '[data-play-bar]', progression.bars.size
    end
  end
end
