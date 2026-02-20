# frozen_string_literal: true

require "spec_helper"
require "open_mercato/testing"

RSpec.describe OpenMercato::Testing::WebhookHelpers do
  include described_class

  after { OpenMercato::Webhooks::Handler.clear! }

  describe "#simulate_mercato_webhook" do
    it "dispatches event to registered handlers" do
      received = nil
      OpenMercato::Webhooks::Handler.on("test.event") { |e| received = e }

      event = simulate_mercato_webhook("test.event", data: { "id" => "123" })

      expect(received).not_to be_nil
      expect(received.record_id).to eq("123")
      expect(event.type).to eq("test.event")
    end
  end

  describe "#signed_mercato_webhook_request" do
    it "produces valid signature" do
      result = signed_mercato_webhook_request("test.event", data: { "id" => "456" })

      expect(result[:payload]).to be_a(String)
      expect(result[:headers]["X-OpenMercato-Signature"]).to match(/t=\d+,v1=[a-f0-9]{64}/)
      expect(result[:headers]["Content-Type"]).to eq("application/json")

      # Verify signature is actually valid
      expect do
        OpenMercato::Webhooks::Signature.verify!(
          payload: result[:payload],
          signature: result[:headers]["X-OpenMercato-Signature"],
          secret: OpenMercato.configuration.webhook_secret
        )
      end.not_to raise_error
    end
  end
end
