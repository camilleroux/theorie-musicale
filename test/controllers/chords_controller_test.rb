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
end

