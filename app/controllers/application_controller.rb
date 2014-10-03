class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def token_authentication
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(token: token)
    end
  end

  def default_serializer_options
    {root: false}
  end
end
