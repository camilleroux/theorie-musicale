require 'test_helper'

class IntervalsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/intervalles'
    assert_response :success
  end

  test 'should show interval' do
    get "/intervalles/#{Interval.new(2, :m).to_param}"
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
    get "/intervalles/#{Interval.new(5, :J).to_param}"
    assert_select 'title', 'Quinte juste : 3,5 tons, renversement et piano | Théorie musicale'
  end

  test 'should render piano diagram' do
    get "/intervalles/#{Interval.new(5, :J).to_param}/piano.svg"
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end

  test 'should give standards to recognize the interval by ear' do
    # Names with accents are linked double-encoded (augment%25C3%25A9e): follow the redirect to that URL
    get "/intervalles/#{Interval.new(4, :aug).to_param}"
    follow_redirect!
    assert_select '#oreille cite', 'Maria'

    # The tritone has the same sound under both names
    get "/intervalles/#{Interval.new(5, :dim).to_param}"
    follow_redirect!
    assert_select '#oreille cite', 'Maria'

    get "/intervalles/#{Interval.new(8, :J).to_param}"
    assert_select '#oreille h2', "Reconnaître l'octave juste à l'oreille"

    get "/intervalles/#{Interval.new(9, :M).to_param}"
    assert_select '#oreille', false
  end
end
