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
end

