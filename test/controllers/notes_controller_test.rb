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

  test 'should not find an unknown note' do
    get '/notes/null'
    assert_response :not_found
  end

  test 'should not find chords, scales, modes or intervals in an unknown key' do
    ['/tonalite/null/accords', '/tonalite/null/gammes/majeure', '/tonalite/null/gammes/majeure/modes/ionien',
     '/tonalite/null/intervalles/5J-quinte+juste'].each do |path|
      get path
      assert_response :not_found, path
    end
  end

  test 'should render piano diagram' do
    get '/notes/c/piano.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end
end
