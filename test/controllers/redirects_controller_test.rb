require 'test_helper'

class RedirectsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect unknown uppercase paths to lowercase' do
    get '/Accords'
    assert_redirected_to '/accords'
    assert_response :moved_permanently

    get '/Tonalite/G/Accords/Mineur-7?x=1'
    assert_redirected_to '/tonalite/g/accords/mineur-7?x=1'
  end

  test 'should redirect uppercase slugs matching a route' do
    get '/accords/Majeur-7'
    assert_redirected_to '/accords/majeur-7'
    assert_response :moved_permanently
  end

  test 'should keep interval slugs, which contain uppercase letters' do
    get "/intervalles/#{Interval.new(3, :M).to_param}"
    assert_response :success
  end

  test 'should not find unknown lowercase paths' do
    get '/accords/inconnu'
    assert_response :not_found

    get '/Inconnu'
    assert_redirected_to '/inconnu'
  end
end
