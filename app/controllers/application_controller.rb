class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # throttle_api a service named Rate::Limiter
  # Rate::Limiter is responsible for maintaing the number of requests made by a client for a url
  def throttle_api
    Rate::Limiter.new(request.env['REMOTE_ADDR'], request.env['REQUEST_PATH']).set
  end
end
