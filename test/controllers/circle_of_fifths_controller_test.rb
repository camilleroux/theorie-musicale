require 'test_helper'

class CircleOfFifthsControllerTest < ActionDispatch::IntegrationTest
  test 'should show every key with its chords' do
    get '/cycle-des-quintes'
    assert_response :success
    assert_select 'h1', 'Cycle des quintes'
    assert_select '.circle__wedge', 12
    assert_select '.circle-panel', 12
    assert_select '#tonalite-g h2', 'Sol majeur (G)'
    assert_select '#tonalite-g', /1 dièse \(fa♯\)/
    assert_select '#tonalite-g a[href=?]', '/tonalite/a/accords/mineur-7', text: 'Am7'
    # C pages are canonicalized to the key-less URL
    assert_select '#tonalite-c a[href=?]', '/accords/majeur-7', text: 'Cmaj7'
  end

  test 'should spell the tritone substitute the usual way' do
    get '/cycle-des-quintes'
    assert_select '#tonalite-c', /on remplace G7 par D♭7/
    assert_select '#tonalite-gb', /on remplace D♭7 par G7/
  end

  test 'should leave the Space bar alone, every key having its own panel' do
    get '/cycle-des-quintes'
    assert_select '.play-button[data-shortcut]', 0
  end
end
