class HomeController < ApplicationController
	# before index call throttle_api
	# throttle_api when called before an action will put rate limit on route corresponding to that action
  before_action :throttle_api, only: :index

  # correspongin to root path, return plain text 'ok'
  def index
    render plain: 'ok'
  end
end