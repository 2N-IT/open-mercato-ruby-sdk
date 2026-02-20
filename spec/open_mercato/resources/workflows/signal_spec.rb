# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Workflows::Signal do
  let(:base_url) { "https://test.open-mercato.local" }

  it "sends a signal to correlated workflow instances" do
    stub_request(:post, "#{base_url}/api/workflows/signals")
      .to_return(status: 200,
                 body: { success: true, message: "Signal sent to 2 workflow(s)", count: 2 }.to_json,
                 headers: { "Content-Type" => "application/json" })

    result = described_class.send_signal(
      correlation_key: "order-123",
      signal_name: "payment_received",
      payload: { amount: "100.00" }
    )
    expect(result["success"]).to be true
    expect(result["count"]).to eq(2)
  end
end
