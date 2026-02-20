# frozen_string_literal: true

module OpenMercato
  class Configuration
    attr_accessor :api_url, :api_key, :tenant_id, :organization_id,
                  :webhook_secret, :webhook_tolerance,
                  :timeout, :open_timeout, :retry_count,
                  :logger, :debug,
                  :async_webhooks, :raise_webhook_errors

    def initialize
      @api_url = ENV.fetch("OPEN_MERCATO_URL", nil)
      @api_key = ENV.fetch("OPEN_MERCATO_API_KEY", nil)
      @tenant_id = ENV.fetch("OPEN_MERCATO_TENANT_ID", nil)
      @organization_id = ENV.fetch("OPEN_MERCATO_ORG_ID", nil)
      @webhook_secret = ENV.fetch("OPEN_MERCATO_WEBHOOK_SECRET", nil)
      @webhook_tolerance = 300
      @timeout = 30
      @open_timeout = 10
      @retry_count = 3
      @logger = nil
      @debug = false
      @async_webhooks = true
      @raise_webhook_errors = false
    end

    def validate!
      raise Error, "api_url is required" if api_url.nil? || api_url.to_s.empty?
      raise Error, "api_key is required" if api_key.nil? || api_key.to_s.empty?
    end
  end
end
