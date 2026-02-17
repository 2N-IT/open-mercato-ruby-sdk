require "open_mercato"
require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before(:each) do
    OpenMercato.reset!
    OpenMercato.configure do |c|
      c.api_url = "https://test.open-mercato.local"
      c.api_key = "omk_test_key"
      c.tenant_id = "test-tenant-id"
      c.organization_id = "test-org-id"
      c.webhook_secret = "test-webhook-secret"
    end
  end
end