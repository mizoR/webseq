class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :access_token

  def access_token
    session[:access_token] ||= SecureRandom.uuid
  end
end
