require 'test_helper'

class ProgressionsControllerTest < ActionDispatch::IntegrationTest
  test 'should list progressions' do
    get '/progressions'
    assert_response :success
    assert_select 'h2 a', Progression.all.size
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
end
