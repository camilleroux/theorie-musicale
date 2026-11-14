require 'test_helper'

class LlmsControllerTest < ActionDispatch::IntegrationTest
  test 'should describe the site for AI assistants' do
    get '/llms.txt'
    assert_response :success
    assert_equal 'text/plain', response.media_type
    assert response.body.start_with?("# Théorie musicale\n\n> ")
    assert_includes response.body, '[Accord mineur 7 (Cm7, do mineur 7)](http://www.example.com/accords/mineur-7)'
    assert_includes response.body, '[Mode dorien](http://www.example.com/gammes/majeure/modes/dorien)'
  end
end
