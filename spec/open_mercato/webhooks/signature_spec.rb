require "spec_helper"

RSpec.describe OpenMercato::Webhooks::Signature do
  let(:secret) { "test-webhook-secret" }
  let(:payload) { '{"event":"test"}' }
  let(:timestamp) { Time.now.to_i }

  describe ".compute" do
    it "generates HMAC-SHA256 hex digest" do
      result = described_class.compute(timestamp: timestamp, payload: payload, secret: secret)
      expect(result).to match(/\A[a-f0-9]{64}\z/)
    end

    it "produces consistent results" do
      a = described_class.compute(timestamp: 12345, payload: "test", secret: "key")
      b = described_class.compute(timestamp: 12345, payload: "test", secret: "key")
      expect(a).to eq(b)
    end
  end

  describe ".verify!" do
    let(:sig) { described_class.compute(timestamp: timestamp, payload: payload, secret: secret) }
    let(:header) { "t=#{timestamp},v1=#{sig}" }

    it "passes for valid signature" do
      expect {
        described_class.verify!(payload: payload, signature: header, secret: secret)
      }.not_to raise_error
    end

    it "raises for missing signature" do
      expect {
        described_class.verify!(payload: payload, signature: nil, secret: secret)
      }.to raise_error(OpenMercato::Webhooks::SignatureError, /No signature/)
    end

    it "raises for empty signature" do
      expect {
        described_class.verify!(payload: payload, signature: "", secret: secret)
      }.to raise_error(OpenMercato::Webhooks::SignatureError, /No signature/)
    end

    it "raises for missing secret" do
      expect {
        described_class.verify!(payload: payload, signature: header, secret: nil)
      }.to raise_error(OpenMercato::Webhooks::SignatureError, /No webhook secret/)
    end

    it "raises for invalid signature" do
      expect {
        described_class.verify!(payload: payload, signature: "t=#{timestamp},v1=invalid_hex_that_is_exactly_sixty_four_characters_long_padding_", secret: secret)
      }.to raise_error(OpenMercato::Webhooks::SignatureError, /mismatch/)
    end

    it "raises for expired timestamp" do
      old_ts = Time.now.to_i - 600
      old_sig = described_class.compute(timestamp: old_ts, payload: payload, secret: secret)
      old_header = "t=#{old_ts},v1=#{old_sig}"

      expect {
        described_class.verify!(payload: payload, signature: old_header, secret: secret, tolerance: 300)
      }.to raise_error(OpenMercato::Webhooks::SignatureError, /too old/)
    end

    it "passes when no tolerance set" do
      old_ts = Time.now.to_i - 9999
      old_sig = described_class.compute(timestamp: old_ts, payload: payload, secret: secret)
      old_header = "t=#{old_ts},v1=#{old_sig}"

      expect {
        described_class.verify!(payload: payload, signature: old_header, secret: secret, tolerance: nil)
      }.not_to raise_error
    end
  end
end