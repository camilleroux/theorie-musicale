require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect a chord symbol to its page' do
    get '/recherche', params: { q: 'Bbmaj7' }
    assert_redirected_to '/tonalite/bb/accords/majeur-7'

    get '/recherche', params: { q: 'F#m7b5' }
    assert_redirected_to '/tonalite/fd/accords/demi-diminue'
  end

  test 'should understand french names' do
    get '/recherche', params: { q: 'la mineur 7' }
    assert_redirected_to '/tonalite/a/accords/mineur-7'

    # D dorian belongs to C major: the key-less mode page
    get '/recherche', params: { q: 'ré dorien' }
    assert_redirected_to '/gammes/majeure/modes/dorien'
  end

  test 'should find intervals and progressions' do
    get '/recherche', params: { q: 'quinte juste' }
    assert_redirected_to "/intervalles/#{Interval.new(5, :J).to_param}"

    get '/recherche', params: { q: '2 5 1' }
    assert_redirected_to '/progressions/ii-v-i-majeur'
  end

  test 'should list ambiguous results and handle no result' do
    get '/recherche', params: { q: 'do majeur' }
    assert_response :success
    assert_select '.search-results a', 2

    get '/recherche', params: { q: 'zzz' }
    assert_response :success
    assert_select 'meta[name=robots][content=noindex]'
  end
end
