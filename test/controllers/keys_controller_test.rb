require 'test_helper'

class KeysControllerTest < ActionDispatch::IntegrationTest
  test 'should show a major key' do
    get '/tonalite/d'
    assert_response :success
    assert_select 'title', 'Tonalité de ré majeur : armure, accords et gamme | Théorie musicale'
    assert_select 'h1', /Tonalité\s+D\s+ré majeur/
    assert_select '.detail-hero__facts', /2 dièses \(fa♯ et do♯\)/
    assert_select 'table a[href=?]', '/tonalite/a/accords/septieme-de-dominante', text: 'A7'
    assert_select '.faq h3', 4
  end

  test 'should show keys written with sharps and seven flats' do
    get '/tonalite/fd'
    assert_select '.detail-hero__facts', /6 dièses/
    get '/tonalite/cb'
    assert_select '.detail-hero__facts', /7 bémols/
  end

  test 'should redirect keys without key signature to their enharmonic' do
    get '/tonalite/gd'
    assert_redirected_to 'http://www.example.com/tonalite/ab'
    assert_response :moved_permanently
  end

  test 'should not find the removed chord quality pages' do
    get '/tonalite/d/qualite'
    assert_response :not_found
  end
end
