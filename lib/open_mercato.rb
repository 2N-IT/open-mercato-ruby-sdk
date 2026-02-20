# frozen_string_literal: true

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

  # Alias for design doc compatibility.
  # Lazily resolved on first access since Webhooks::SignatureError is a secondary
  # constant in webhooks/signature.rb and may not be autoloaded by Zeitwerk yet.
  def self.const_missing(name)
    if name == :WebhookSignatureError
      require_relative "open_mercato/webhooks/signature"
      const_set(:WebhookSignatureError, Webhooks::SignatureError)
    else
      super
    end
  end
end
