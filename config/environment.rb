# Load the Rails application.
require_relative 'application'

Rails.application.configure do
  require 'throttler'
  config.middleware.use Throttler
end

# Initialize the Rails application.
Rails.application.initialize!
