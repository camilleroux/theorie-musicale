require 'test_helper'

class ModesControllerTest < ActionDispatch::IntegrationTest
  test 'should show mode' do
    scale = Scale.first
    mode = scale.modes.first
    get "/gammes/#{scale.slug}/modes/#{mode.slug}"
    assert_response :success
  end
end

