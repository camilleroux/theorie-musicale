require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get a-propos page' do
    get page_path('a-propos')
    assert_response :success
  end

  test 'should get ressources page' do
    get page_path('ressources')
    assert_response :success
  end
end

