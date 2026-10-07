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

  test 'should use the french name in the title' do
    get note_url('c')
    assert_select 'title', 'Note C (do en français) : portée et piano | Théorie musicale'
  end

  test 'should render piano diagram' do
    get '/notes/c/piano.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end
end
