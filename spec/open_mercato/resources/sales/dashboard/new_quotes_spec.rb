# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Sales::Dashboard::NewQuotes do
  let(:base_url) { "https://test.open-mercato.local" }

  it "fetches new quotes widget data" do
    stub_request(:get, "#{base_url}/api/sales/dashboard/widgets/new-quotes")
      .with(query: hash_including("limit" => "5"))
      .to_return(
        status: 200,
        body: {
          items: [{ id: "1", quoteNumber: "QUO-001", status: "draft",
                    netAmount: "500.00", currency: "USD", convertedOrderId: nil }],
          total: 1,
          dateRange: { from: "2026-01-01T00:00:00Z", to: "2026-01-02T00:00:00Z" }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    result = described_class.list(limit: 5)
    expect(result["items"].first["quoteNumber"]).to eq("QUO-001")
    expect(result["total"]).to eq(1)
  end
end
