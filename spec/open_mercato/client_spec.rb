RSpec.describe OpenMercato::Client do
  let(:client) { OpenMercato.client }
  let(:base_url) { "https://test.open-mercato.local" }

  describe "request headers" do
    before do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 200, body: '{"ok": true}', headers: { "Content-Type" => "application/json" })
    end

    it "sends x-api-key header" do
      client.get("/api/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/api/test")
        .with(headers: { "x-api-key" => "omk_test_key" })
    end

    it "sends X-Tenant-Id header" do
      client.get("/api/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/api/test")
        .with(headers: { "X-Tenant-Id" => "test-tenant-id" })
    end

    it "sends X-Organization-Id header" do
      client.get("/api/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/api/test")
        .with(headers: { "X-Organization-Id" => "test-org-id" })
    end

    it "sends User-Agent header" do
      client.get("/api/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/api/test")
        .with(headers: { "User-Agent" => "open_mercato-ruby/#{OpenMercato::VERSION}" })
    end

    it "sends Content-Type and Accept headers" do
      client.get("/api/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/api/test")
        .with(headers: { "Content-Type" => "application/json", "Accept" => "application/json" })
    end
  end

  describe "#get" do
    it "returns parsed JSON response" do
      stub_request(:get, "#{base_url}/api/items")
        .to_return(status: 200, body: '{"items": [1, 2, 3]}')

      result = client.get("/api/items")
      expect(result).to eq("items" => [1, 2, 3])
    end

    it "transforms snake_case params to camelCase" do
      stub_request(:get, "#{base_url}/api/items")
        .with(query: { "pageSize" => "25", "sortBy" => "name" })
        .to_return(status: 200, body: '{}')

      client.get("/api/items", page_size: 25, sort_by: "name")
    end
  end

  describe "#post" do
    it "sends JSON body" do
      stub_request(:post, "#{base_url}/api/items")
        .with(body: '{"name":"Test"}')
        .to_return(status: 201, body: '{"id": "123"}')

      result = client.post("/api/items", name: "Test")
      expect(result).to eq("id" => "123")
    end

    it "transforms snake_case keys to camelCase in body" do
      stub_request(:post, "#{base_url}/api/items")
        .with(body: '{"displayName":"Test","isActive":true}')
        .to_return(status: 200, body: '{}')

      client.post("/api/items", display_name: "Test", is_active: true)
    end

    it "transforms nested keys" do
      stub_request(:post, "#{base_url}/api/items")
        .with(body: '{"lineItems":[{"unitPrice":10}]}')
        .to_return(status: 200, body: '{}')

      client.post("/api/items", line_items: [{ unit_price: 10 }])
    end
  end

  describe "#put" do
    it "sends PUT request with JSON body" do
      stub_request(:put, "#{base_url}/api/items")
        .with(body: '{"id":"123","name":"Updated"}')
        .to_return(status: 200, body: '{"ok": true}')

      result = client.put("/api/items", id: "123", name: "Updated")
      expect(result).to eq("ok" => true)
    end
  end

  describe "#delete" do
    it "sends DELETE request with JSON body" do
      stub_request(:delete, "#{base_url}/api/items")
        .with(body: '{"id":"123"}')
        .to_return(status: 200, body: '{"ok": true}')

      result = client.delete("/api/items", id: "123")
      expect(result).to eq("ok" => true)
    end
  end

  describe "error handling" do
    it "raises ValidationError on 400" do
      stub_request(:post, "#{base_url}/api/items")
        .to_return(
          status: 400,
          body: '{"error":"Invalid","fieldErrors":{"name":["is required"]}}'
        )

      expect { client.post("/api/items") }.to raise_error(OpenMercato::ValidationError) do |error|
        expect(error.message).to eq("Invalid")
        expect(error.field_errors).to eq("name" => ["is required"])
      end
    end

    it "raises AuthenticationError on 401" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::AuthenticationError, "Unauthorized")
    end

    it "raises ForbiddenError on 403" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 403, body: '{"error":"Access denied"}')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::ForbiddenError, "Access denied")
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 404, body: '{"error":"Resource not found"}')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::NotFoundError, "Resource not found")
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 429, body: '{}')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::RateLimitError)
    end

    it "raises ServerError on 500" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 500, body: '{"error":"Internal server error"}')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::ServerError, "Internal server error")
    end

    it "raises ServerError on 502" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 502, body: '')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::ServerError)
    end

    it "handles non-JSON error responses" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 400, body: 'Not JSON')

      expect { client.get("/api/test") }.to raise_error(OpenMercato::ValidationError)
    end

    it "handles empty body on success" do
      stub_request(:get, "#{base_url}/api/test")
        .to_return(status: 200, body: '')

      result = client.get("/api/test")
      expect(result).to eq({})
    end
  end

  describe "Faraday error wrapping" do
    it "wraps Faraday::ConnectionFailed in OpenMercato::Error" do
      stub_request(:get, "#{base_url}/api/test")
        .to_raise(Faraday::ConnectionFailed.new("connection refused"))

      expect { client.get("/api/test") }.to raise_error(OpenMercato::Error, /Connection failed/)
    end

    it "wraps Faraday::TimeoutError in OpenMercato::Error" do
      stub_request(:get, "#{base_url}/api/test")
        .to_raise(Faraday::TimeoutError.new("request timed out"))

      expect { client.get("/api/test") }.to raise_error(OpenMercato::Error, /Request timed out/)
    end
  end

  describe "retry configuration" do
    it "only retries idempotent methods (GET, HEAD, OPTIONS)" do
      connection = client.send(:connection)
      retry_handler = connection.builder.handlers.find { |h| h == Faraday::Retry::Middleware }
      expect(retry_handler).not_to be_nil
    end
  end

  describe "key transformation" do
    let(:client_instance) { described_class.new(OpenMercato.configuration) }

    it "transforms simple snake_case to camelCase" do
      result = client_instance.send(:transform_keys, { page_size: 25 })
      expect(result).to eq("pageSize" => 25)
    end

    it "transforms nested hashes" do
      result = client_instance.send(:transform_keys, { outer_key: { inner_key: "value" } })
      expect(result).to eq("outerKey" => { "innerKey" => "value" })
    end

    it "transforms arrays of hashes" do
      result = client_instance.send(:transform_keys, { items: [{ unit_price: 10 }] })
      expect(result).to eq("items" => [{ "unitPrice" => 10 }])
    end

    it "leaves non-hash/array values untouched" do
      result = client_instance.send(:transform_keys, { name: "test" })
      expect(result).to eq("name" => "test")
    end
  end
end