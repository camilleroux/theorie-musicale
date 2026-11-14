require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end

  test 'should load scripts without blocking rendering' do
    get '/'
    assert_select 'script[src*=application][defer]'
  end
end
