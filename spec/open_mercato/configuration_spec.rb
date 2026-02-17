RSpec.describe OpenMercato::Configuration do
  describe "defaults" do
    subject(:config) { described_class.new }

    before do
      ENV.delete("OPEN_MERCATO_URL")
      ENV.delete("OPEN_MERCATO_API_KEY")
      ENV.delete("OPEN_MERCATO_TENANT_ID")
      ENV.delete("OPEN_MERCATO_ORG_ID")
      ENV.delete("OPEN_MERCATO_WEBHOOK_SECRET")
    end

    it "has nil api_url by default" do
      expect(config.api_url).to be_nil
    end

    it "has nil api_key by default" do
      expect(config.api_key).to be_nil
    end

    it "has nil tenant_id by default" do
      expect(config.tenant_id).to be_nil
    end

    it "has nil organization_id by default" do
      expect(config.organization_id).to be_nil
    end

    it "has default timeout of 30" do
      expect(config.timeout).to eq(30)
    end

    it "has default open_timeout of 10" do
      expect(config.open_timeout).to eq(10)
    end

    it "has default retry_count of 3" do
      expect(config.retry_count).to eq(3)
    end

    it "has default webhook_tolerance of 300" do
      expect(config.webhook_tolerance).to eq(300)
    end

    it "has debug disabled by default" do
      expect(config.debug).to be false
    end

    it "has async_webhooks enabled by default" do
      expect(config.async_webhooks).to be true
    end

    it "has raise_webhook_errors disabled by default" do
      expect(config.raise_webhook_errors).to be false
    end
  end

  describe "ENV reading" do
    before do
      ENV["OPEN_MERCATO_URL"] = "https://env.example.com"
      ENV["OPEN_MERCATO_API_KEY"] = "omk_env_key"
      ENV["OPEN_MERCATO_TENANT_ID"] = "env-tenant"
      ENV["OPEN_MERCATO_ORG_ID"] = "env-org"
      ENV["OPEN_MERCATO_WEBHOOK_SECRET"] = "env-secret"
    end

    after do
      ENV.delete("OPEN_MERCATO_URL")
      ENV.delete("OPEN_MERCATO_API_KEY")
      ENV.delete("OPEN_MERCATO_TENANT_ID")
      ENV.delete("OPEN_MERCATO_ORG_ID")
      ENV.delete("OPEN_MERCATO_WEBHOOK_SECRET")
    end

    subject(:config) { described_class.new }

    it "reads api_url from ENV" do
      expect(config.api_url).to eq("https://env.example.com")
    end

    it "reads api_key from ENV" do
      expect(config.api_key).to eq("omk_env_key")
    end

    it "reads tenant_id from ENV" do
      expect(config.tenant_id).to eq("env-tenant")
    end

    it "reads organization_id from ENV" do
      expect(config.organization_id).to eq("env-org")
    end

    it "reads webhook_secret from ENV" do
      expect(config.webhook_secret).to eq("env-secret")
    end
  end

  describe "#validate!" do
    subject(:config) { described_class.new }

    before do
      ENV.delete("OPEN_MERCATO_URL")
      ENV.delete("OPEN_MERCATO_API_KEY")
    end

    it "raises when api_url is missing" do
      config.api_key = "omk_test"
      expect { config.validate! }.to raise_error(OpenMercato::Error, "api_url is required")
    end

    it "raises when api_url is empty string" do
      config.api_url = ""
      config.api_key = "omk_test"
      expect { config.validate! }.to raise_error(OpenMercato::Error, "api_url is required")
    end

    it "raises when api_key is missing" do
      config.api_url = "https://example.com"
      expect { config.validate! }.to raise_error(OpenMercato::Error, "api_key is required")
    end

    it "raises when api_key is empty string" do
      config.api_url = "https://example.com"
      config.api_key = ""
      expect { config.validate! }.to raise_error(OpenMercato::Error, "api_key is required")
    end

    it "does not raise when both are present" do
      config.api_url = "https://example.com"
      config.api_key = "omk_test"
      expect { config.validate! }.not_to raise_error
    end
  end

  describe "OpenMercato.configure" do
    it "yields the configuration" do
      OpenMercato.reset!
      OpenMercato.configure do |config|
        config.api_url = "https://custom.example.com"
        config.api_key = "omk_custom"
      end

      expect(OpenMercato.configuration.api_url).to eq("https://custom.example.com")
      expect(OpenMercato.configuration.api_key).to eq("omk_custom")
    end
  end

  describe "OpenMercato.reset!" do
    it "resets configuration to defaults" do
      OpenMercato.configure do |config|
        config.timeout = 99
      end

      expect(OpenMercato.configuration.timeout).to eq(99)

      OpenMercato.reset!

      expect(OpenMercato.configuration.timeout).to eq(30)
    end
  end
end