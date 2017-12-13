module Rate
  class Configuration
    attr_accessor :timer, :max_requests

    # Configuration pattern to set the configuration of rate module from initializers
    def initialize
      @timer = 3600
      @max_requests = 100
    end
  end
end