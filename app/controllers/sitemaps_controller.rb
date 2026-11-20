# /sitemap.xml: generated from config/sitemap.rb at image build time (see Dockerfile).
# Served here rather than from public/ so Cloudflare keeps it one hour, not one year.
class SitemapsController < ApplicationController
  def show
    path = Rails.root.join('tmp/sitemaps/sitemap.xml')
    raise ActionController::RoutingError, 'Sitemap not generated: run bin/rails sitemap:refresh:no_ping' unless path.exist?

    expires_in 1.hour, public: true
    send_file path, type: 'application/xml', disposition: 'inline'
  end
end
