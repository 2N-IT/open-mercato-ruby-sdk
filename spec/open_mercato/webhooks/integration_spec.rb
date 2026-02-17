require "spec_helper"

RSpec.describe "Webhook flow integration" do
  after { OpenMercato::Webhooks::Handler.clear! }

  it "verifies signature, parses event, dispatches to handler" do
    secret = "test-webhook-secret"
    payload = {
      event: "sales.orders.created",
      data: { id: "uuid-123", orderNumber: "ORD-001" },
      tenantId: "t1",
      organizationId: "o1",
      timestamp: Time.now.iso8601
    }.to_json

    timestamp = Time.now.to_i
    sig = OpenMercato::Webhooks::Signature.compute(
      timestamp: timestamp, payload: payload, secret: secret
    )

    # Verify signature
    expect {
      OpenMercato::Webhooks::Signature.verify!(
        payload: payload,
        signature: "t=#{timestamp},v1=#{sig}",
        secret: secret
      )
    }.not_to raise_error

    # Parse event
    parsed = JSON.parse(payload)
    event = OpenMercato::Webhooks::Event.new(
      type: parsed["event"],
      data: parsed["data"],
      tenant_id: parsed["tenantId"],
      organization_id: parsed["organizationId"]
    )

    # Dispatch
    received = nil
    OpenMercato::Webhooks::Handler.on("sales.orders.created") { |e| received = e }
    OpenMercato::Webhooks::Handler.dispatch(event)

    expect(received).not_to be_nil
    expect(received.record_id).to eq("uuid-123")
    expect(received).to be_created
  end

  it "rejects tampered payloads" do
    secret = "test-webhook-secret"
    payload = '{"event":"test"}'
    timestamp = Time.now.to_i
    sig = OpenMercato::Webhooks::Signature.compute(
      timestamp: timestamp, payload: payload, secret: secret
    )

    tampered = '{"event":"hacked"}'
    expect {
      OpenMercato::Webhooks::Signature.verify!(
        payload: tampered,
        signature: "t=#{timestamp},v1=#{sig}",
        secret: secret
      )
    }.to raise_error(OpenMercato::Webhooks::SignatureError)
  end
end