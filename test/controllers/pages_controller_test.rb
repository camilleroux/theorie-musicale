require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get a-propos page' do
    get page_path('a-propos')
    assert_response :success
    assert_select '.author__bio a[href=?]', 'https://art.camilleroux.com/work/resilience/', text: 'Résilience'
  end

  test 'should describe the author like www.camilleroux.com, with Wikidata first' do
    get page_path('a-propos')
    graph = JSON.parse(css_select('script[type="application/ld+json"]').first.text)['@graph']
    person = graph.find { |node| node['@type'] == 'Person' }
    assert_equal 'https://www.camilleroux.com/#person', person['@id']
    assert_equal 'https://www.wikidata.org/wiki/Q141371390', person['sameAs'].first
    assert_equal 'Human Coders', person.dig('worksFor', 'name')
  end

  test 'should get ressources page' do
    get page_path('ressources')
    assert_response :success
  end
end

