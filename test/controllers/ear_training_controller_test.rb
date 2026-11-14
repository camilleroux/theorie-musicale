require 'test_helper'

class EarTrainingControllerTest < ActionDispatch::IntegrationTest
  test 'should list standards for each interval, up and down' do
    get '/reconnaitre-les-intervalles'
    assert_response :success
    assert_select '.ear-interval', 12
    assert_select '#4j cite', 'All the Things You Are'
    assert_select '#7m cite', 'Somewhere'
    assert_select '#3m .play-button[data-play=melody][data-notes=?]', '["Eb/4","C/4"]', text: 'Descendant'
  end
end
