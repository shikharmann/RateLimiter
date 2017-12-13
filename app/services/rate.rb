module Rate
  class << self
    attr_writer :configuration
  end

  # returns the configuration of Rate module
  def self.configuration
    @configuration ||= Configuration.new
  end

  # resets the configuration of Rate module to defaul
  def self.reset
    @configuration = Configuration.new
  end

  # sets the configuration of rate module
  # typically called from initializer rate_parameters.rb
  def self.configure
    yield(configuration)
  end
end