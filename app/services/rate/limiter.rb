module Rate
  class Limiter
    attr_accessor :key

    # instace variable key is set during initialization
    # key is formed from combination of ip of client and url requested
    # example: if client at ip 127.0.0.1 requests root then key is REMOTE_ADDR_127.0.0.1-REQUEST_PATH_/
    def initialize(remote_addr, request_path)
      @key = "REMOTE_ADDR_#{remote_addr}-REQUEST_PATH_#{request_path}"
    end

    # value stored corresponding to key is count of requests made by the client for the url
    # key value pair expires after n seconds where n is value of timer stored in configuration of Rate module
    # if key exists then increment its value else set the value corresponding to key to 1
    def set
      if $redis.exists(@key)
        $redis.incr(@key)
      else
        $redis.setex(@key, Rate.configuration.timer, 1)
      end
    end

    # checks if requests made by the client for the url exceed the rate limit
    # returns true if the value stored corresponding to key is <= to max_requests in configuration of Rate module
    def exceeded?
      $redis.exists(@key) && Rate.configuration.max_requests <= $redis.get(@key).to_i
    end

    # returns the time to live of key value pair in redis
    # corresponds to the seconds left after which rate limit will be refreshed
    def expiry_time
      $redis.ttl(@key)
    end
  end
end