require 'test_helper'

class SitemapsControllerTest < ActionDispatch::IntegrationTest
  test 'should serve the generated sitemap' do
    path = Rails.root.join('tmp/sitemaps/sitemap.xml')
    FileUtils.mkdir_p(path.dirname)
    File.write(path, '<urlset/>') unless path.exist?

    get '/sitemap.xml'
    assert_response :success
    assert_equal 'application/xml', response.media_type
    assert_includes response.body, '<urlset'
    assert_includes response.headers['Cache-Control'], 'max-age=3600'
  end
end
