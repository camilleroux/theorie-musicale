require 'test_helper'

class ScalesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/gammes'
    assert_response :success
  end

  test 'should show scale' do
    scale = Scale.first
    get "/gammes/#{scale.slug}"
    assert_response :success
  end

  test 'should title scale pages in a key after their modes' do
    get '/tonalite/d/gammes/majeure'
    assert_select 'title', 'Modes de la gamme de ré majeur et harmonisation | Théorie musicale'
    assert_select 'h1', 'Modes de la gamme de ré majeur'
    assert_select 'meta[name=description][content^=?]', 'Modes de la gamme de ré majeur : ré majeur, mi dorien'
    assert_select '.faq h3', /Quelles sont les notes de la gamme de ré majeur/

    get '/gammes/majeure'
    assert_select 'h1', 'Gamme majeure'
  end

  test 'should canonicalize a one-mode scale in a key to its mode' do
    get '/tonalite/d/gammes/ton-ton'
    assert_select 'link[rel=canonical][href=?]', 'http://www.example.com/tonalite/d/gammes/ton-ton/modes/ton-ton'
  end
end
