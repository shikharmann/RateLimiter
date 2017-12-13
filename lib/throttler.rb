class Throttler
  def initialize(app)
    @app = app
  end

  # calls application if the rate limit of the client for a url is not reached
  # responds with 429 in case rate limit has been reached
  def call(env)
    limiter = Rate::Limiter.new(env['REMOTE_ADDR'], env['REQUEST_PATH'])
    if limiter.exceeded?
      [429, { 'Content-Type' => 'text/html' }, ["Rate limit exceeded. Try again in #{limiter.expiry_time} seconds"]]
    else
      @app.call(env)
    end
  end
end