class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :redirect_if_old_domain

  protected

  def redirect_if_old_domain
    if request.env['HTTP_HOST'] != Rails.application.secrets.default_domain
      redirect_to("http://#{Rails.application.secrets.default_domain}#{request.path}", :status => 301) and return
    end
  end
end
