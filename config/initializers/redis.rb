options = Rails.application.config_for(:redis)
$redis = Redis.new(options)