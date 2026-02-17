require "json"
require "faraday"
require "faraday/retry"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.ignore("#{__dir__}/generators")
loader.setup

module OpenMercato
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset!
      @configuration = Configuration.new
      @client = nil
    end

    def client
      configuration.validate!
      @client ||= Client.new(configuration)
    end
  end
end