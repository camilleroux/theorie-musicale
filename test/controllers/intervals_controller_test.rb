require 'test_helper'

class IntervalsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/intervalles'
    assert_response :success
  end

  test 'should show interval' do
    get interval_path(Interval.new(2, :m))
    assert_response :success
    assert_select 'title', /Seconde mineure/
  end

  test 'should redirect a bare symbol to the canonical URL' do
    get '/intervalles/2m'
    assert_redirected_to "/intervalles/#{Interval.new(2, :m).to_param}"
    assert_response :moved_permanently
  end

  test 'should redirect lowercased links using the interval name' do
    get '/intervalles/6m-sixte+majeure'
    assert_redirected_to "/intervalles/#{Interval.new(6, :M).to_param}"

    get '/intervalles/5j-quinte+juste'
    assert_redirected_to "/intervalles/#{Interval.new(5, :J).to_param}"
  end

  test 'should not find an unknown interval' do
    get '/intervalles/foo'
    assert_response :not_found
  end

  test 'should use searched names in titles' do
    get interval_path(Interval.new(5, :J))
    assert_select 'title', 'Quinte juste : 3,5 tons, renversement et piano | Théorie musicale'
  end

  test 'should render piano diagram' do
    get "/intervalles/#{Interval.new(5, :J).to_param}/piano.svg"
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end

  test 'should give standards to recognize the interval by ear' do
    get interval_path(Interval.new(4, :aug))
    assert_select '#oreille cite', 'Maria'

    # The tritone has the same sound under both names
    get interval_path(Interval.new(5, :dim))
    assert_select '#oreille cite', 'Maria'

    get interval_path(Interval.new(8, :J))
    assert_select '#oreille h2', "Reconnaître l'octave juste à l'oreille"

    get interval_path(Interval.new(9, :M))
    assert_select '#oreille', false
  end

  test 'should encode accents once' do
    assert_equal '/intervalles/4aug-quarte+augment%C3%A9e', interval_path(Interval.new(4, :aug))

    get '/intervalles/4aug-quarte+augment%C3%A9e'
    assert_response :success
    assert_select 'link[rel=canonical][href=?]', 'http://www.example.com/intervalles/4aug-quarte+augment%C3%A9e'

    get '/tonalite/d/intervalles/7M-septi%C3%A8me+majeure'
    assert_response :success
  end

  test 'should redirect the old double-encoded URLs' do
    get '/intervalles/4aug-quarte+augment%25C3%25A9e'
    assert_response :moved_permanently
    assert_redirected_to 'http://www.example.com/intervalles/4aug-quarte+augment%C3%A9e'

    get '/tonalite/d/intervalles/7M-septi%25C3%25A8me+majeure'
    assert_redirected_to 'http://www.example.com/tonalite/d/intervalles/7M-septi%C3%A8me+majeure'
  end
end
