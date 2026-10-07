require 'test_helper'

class ChordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/accords'
    assert_response :success
  end

  test 'should show chord' do
    chord = Chord.first
    get "/accords/#{chord.slug}"
    assert_response :success
  end

  test 'should use searched symbols in title and description' do
    get '/tonalite/a/accords/mineur-7'
    assert_select 'title', 'Accord Am7 (la mineur 7) : notes, guitare et piano | Théorie musicale'
    assert_select 'meta[name=description][content^=?]', 'Accord Am7 (la mineur 7) : notes A, C, E et G'
    assert_select 'img[src$=?]', '/tonalite/a/accords/mineur-7/guitare-1.svg'
    assert_select 'img[src$=?]', '/tonalite/a/accords/mineur-7/piano.svg'
  end

  test 'should noindex double-altered keys' do
    get '/tonalite/bbb/accords/majeur'
    assert_select 'meta[name=robots][content=noindex]'

    get '/tonalite/bb/accords/majeur'
    assert_select 'meta[name=robots]', false
  end

  test 'should render guitar diagrams' do
    get '/tonalite/a/accords/mineur-7/guitare-1.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
    assert_includes response.body, 'x02010'

    get '/tonalite/a/accords/mineur-7/guitare-4.svg'
    assert_response :not_found
  end

  test 'should render piano diagram' do
    get '/accords/majeur-7/piano.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end

  test 'should let Cloudflare cache pages without session cookie' do
    get '/tonalite/a/accords/mineur-7'
    assert_includes response.headers['Cache-Control'], 's-maxage=3600'
    assert_nil response.headers['Set-Cookie']
  end
end
