# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  add_group "Resources", "lib/open_mercato/resources"
  add_group "Webhooks", "lib/open_mercato/webhooks"
  add_group "Testing", "lib/open_mercato/testing"
  minimum_coverage 80
end

require "open_mercato"
require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before do
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
