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
end
