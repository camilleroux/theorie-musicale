require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get notes_url
    assert_response :success
  end

  test 'should show note C' do
    get note_url('c')
    assert_response :success
  end
end

