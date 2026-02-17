require "spec_helper"
require "active_job"
require_relative "../../app/jobs/open_mercato/webhook_job"

RSpec.describe OpenMercato::WebhookJob do
  after { OpenMercato::Webhooks::Handler.clear! }

  it "deserializes and dispatches event" do
    event_data = {
      "type" => "test.event",
      "data" => { "id" => "123" },
      "tenantId" => "t1",
      "organizationId" => "o1"
    }

    received = nil
    OpenMercato::Webhooks::Handler.on("test.event") { |e| received = e }

    job = described_class.new
    job.perform(event_data)

    expect(received).not_to be_nil
    expect(received.record_id).to eq("123")
  end
end