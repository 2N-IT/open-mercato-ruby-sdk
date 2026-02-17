module OpenMercato
  class Configuration
    attr_accessor :api_url, :api_key, :tenant_id, :organization_id,
                  :webhook_secret, :webhook_tolerance,
                  :timeout, :open_timeout, :retry_count,
                  :logger, :debug,
                  :async_webhooks, :raise_webhook_errors

    def initialize
      @api_url = ENV["OPEN_MERCATO_URL"]
      @api_key = ENV["OPEN_MERCATO_API_KEY"]
      @tenant_id = ENV["OPEN_MERCATO_TENANT_ID"]
      @organization_id = ENV["OPEN_MERCATO_ORG_ID"]
      @webhook_secret = ENV["OPEN_MERCATO_WEBHOOK_SECRET"]
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