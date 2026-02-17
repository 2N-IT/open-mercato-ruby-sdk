module OpenMercato
  module Testing
    def self.setup!
      OpenMercato.configure do |config|
        config.api_url = "https://test.open-mercato.local"
        config.api_key = "omk_test_key"
        config.tenant_id = "test-tenant-id"
        config.organization_id = "test-org-id"
        config.webhook_secret = "test-webhook-secret"
      end
    end
  end
end

require_relative "testing/fake_responses"
require_relative "testing/request_stubs"
require_relative "testing/webhook_helpers"