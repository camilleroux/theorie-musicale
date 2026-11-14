require 'test_helper'

class ChordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/accords'
    assert_response :success
  end

  test 'should show chord' do
    chord = Chord.first
    get "/accords/#{chord.slug}"
    assert_response :success
  end

  test 'should use searched symbols in title and description' do
    get '/tonalite/a/accords/mineur-7'
    assert_select 'title', 'Accord Am7 (la mineur 7) : notes, guitare et piano | Théorie musicale'
    assert_select 'meta[name=description][content^=?]', 'Accord Am7 (la mineur 7) : notes A, C, E et G'
    assert_select 'h1', /Am7/
    assert_select 'img[src$=?]', '/tonalite/a/accords/mineur-7/guitare-1.svg'
    assert_select 'img[src$=?]', '/tonalite/a/accords/mineur-7/piano.svg'
  end

  test 'should noindex double-altered keys' do
    get '/tonalite/bbb/accords/majeur'
    assert_select 'meta[name=robots][content=noindex]'

    get '/tonalite/bb/accords/majeur'
    assert_select 'meta[name=robots]', false
  end

  test 'should render guitar diagrams' do
    get '/tonalite/a/accords/mineur-7/guitare-1.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
    assert_includes response.body, 'x02010'

    get '/tonalite/a/accords/mineur-7/guitare-4.svg'
    assert_response :not_found
  end

  test 'should render piano diagram' do
    get '/accords/majeur-7/piano.svg'
    assert_response :success
    assert_equal 'image/svg+xml', response.media_type
  end

  test 'should let Cloudflare cache pages without session cookie' do
    get '/tonalite/a/accords/mineur-7'
    assert_includes response.headers['Cache-Control'], 's-maxage=3600'
    assert_nil response.headers['Set-Cookie']
  end

  test 'should show extended and suspended chords with guitar diagrams' do
    get '/tonalite/g/accords/neuvieme'
    assert_select 'title', 'Accord G9 (sol neuvième) : notes, guitare et piano | Théorie musicale'
    assert_select 'img[src$=?]', '/tonalite/g/accords/neuvieme/guitare-1.svg'

    get '/tonalite/a/accords/sus-2'
    assert_response :success
    assert_select 'meta[name=description][content^=?]', 'Accord Asus2 (la sus 2) : notes A, B et E'
  end

  test 'should title the keyless chord page after C, the key it shows' do
    get '/accords/majeur-7'
    assert_select 'title', /\AAccord majeur 7 \(Cmaj7, do majeur 7\)/
    assert_select 'meta[name=description][content^=?]', 'Accord majeur 7 : en do, Cmaj7 (do majeur 7), notes C, E, G et B'
    assert_select 'h1', /Cmaj7/

    get '/accords/majeur'
    assert_select 'title', /\AAccord majeur \(C, do majeur\)/
  end

  test 'should link the art site from the author box' do
    get '/tonalite/a/accords/mineur-7'
    assert_select 'a[href=?]', 'https://art.camilleroux.com/'
  end

  test 'should put the searched name in headings' do
    get '/tonalite/a/accords/mineur-7'
    assert_select 'h1', /\AAccord\s+Am7\s+la mineur 7\z/
    assert_select 'h2', 'Accord Am7 à la guitare'
    assert_select 'h2', 'Accord Am7 au piano'

    get '/accords/majeur'
    assert_select 'h1', /\AAccord majeur\s+C\s+do majeur\z/
    assert_select 'h2', 'Accord C à la guitare'
  end

  test 'should define the chord and its role in jazz' do
    get '/tonalite/a/accords/mineur-7'
    assert_select '.detail-intro .lead', /\AL'accord Am7 \(la mineur 7\) compte quatre notes/
    assert_select '.detail-intro a[href=?]', '/progressions/ii-v-i-majeur?tonalite=g', text: 'II-V-I majeur'
    assert_select '.detail-intro', /Am7 – D7 – Gmaj7 en sol majeur/

    get '/accords/majeur-7'
    assert_select '.detail-intro', /En do, Cmaj7 se compose de do, mi, sol et si/
  end

  test 'should answer questions and publish them as structured data' do
    get '/tonalite/a/accords/mineur-7'
    assert_select '.faq h3', "Quelles sont les notes de l'accord Am7\u00A0?"
    graph = JSON.parse(css_select('script[type="application/ld+json"]').first.text)['@graph']
    term = graph.find { |node| node['@type'] == 'DefinedTerm' }
    assert_equal 'Am7', term['termCode']
    faq = graph.find { |node| node['@type'] == 'FAQPage' }
    assert_includes faq['mainEntity'].map { |q| q['name'] }, 'Comment jouer Am7 à la guitare ?'
  end

  test 'should sum up the chord type, tensions and scales' do
    get '/tonalite/g/accords/septieme-de-dominante'
    assert_select '.detail-hero__facts dd', 'Tétrade (4 notes)'
    assert_select '.detail-hero__facts dd', /\A9 \(A\), 13 \(E\)/
    assert_select '.detail-hero__facts dd', /à éviter[[:space:]]: 11 \(C\)/
    assert_select '.detail-hero__facts a[href=?]', '/gammes/majeure/modes/mixolydien', text: 'Mode sol mixolydien'
  end
end
