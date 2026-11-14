require 'test_helper'

class ModesControllerTest < ActionDispatch::IntegrationTest
  test 'should show mode' do
    scale = Scale.first
    mode = scale.modes.first
    get "/gammes/#{scale.slug}/modes/#{mode.slug}"
    assert_response :success
  end

  test 'should use searched names in titles' do
    get '/tonalite/d/gammes/mineure-harmonique/modes/mineure-harmonique'
    assert_select 'title', 'Gamme de ré mineur harmonique : notes et piano | Théorie musicale'

    get '/tonalite/bb/gammes/majeure/modes/dorien'
    assert_select 'title', 'Mode do dorien : notes et piano | Théorie musicale'
  end

  test 'should render piano diagram' do
    get '/tonalite/d/gammes/mineure-harmonique/modes/mineure-harmonique/piano.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end

  test 'should define the mode and the chords it goes with' do
    get '/tonalite/bb/gammes/majeure/modes/dorien'
    assert_select '.detail-intro', /Le mode do dorien compte 7 notes[[:space:]]: do, ré, mi♭, fa, sol, la et si♭\. C'est le 2e mode de la gamme majeure/
    assert_select '.detail-intro', /improviser sur Cm, Cm7/
  end
end
