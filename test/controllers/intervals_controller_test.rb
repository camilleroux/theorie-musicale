require 'test_helper'

class IntervalsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/intervalles'
    assert_response :success
  end

  test 'should show interval' do
    # Interval format is "degree + quality", e.g., "2m" for minor second
    get '/intervalles/2m'
    assert_response :success
  end
end
