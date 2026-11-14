class RedirectsController < ApplicationController
  def lowercase
    redirect_to_lowercase_path or raise ActionController::RoutingError, 'Not Found'
  end
end
