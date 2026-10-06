class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :set_cache_headers

  protected

  # Browsers always revalidate pages; Cloudflare keeps them one hour, so a deploy is live everywhere within the hour.
  # Requires the Cloudflare cache rule to respect origin cache headers.
  def set_cache_headers
    return unless (request.get? || request.head?) && response.media_type == 'text/html' && response.successful?

    # s-maxage only applies to shared caches (Cloudflare), browsers use max-age
    expires_in 0, public: true, must_revalidate: true, 's-maxage': 1.hour.to_i
  end
end
