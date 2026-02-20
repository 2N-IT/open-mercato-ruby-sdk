# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Sales::Dashboard::NewOrders do
  let(:base_url) { "https://test.open-mercato.local" }

  it "fetches new orders widget data" do
    stub_request(:get, "#{base_url}/api/sales/dashboard/widgets/new-orders")
      .with(query: hash_including("datePeriod" => "last24h"))
      .to_return(
        status: 200,
        body: {
          items: [{ id: "1", orderNumber: "ORD-001", status: "pending",
                    netAmount: "100.00", currency: "USD" }],
          total: 1,
          dateRange: { from: "2026-01-01T00:00:00Z", to: "2026-01-02T00:00:00Z" }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    result = described_class.list(date_period: "last24h")
    expect(result["items"].first["orderNumber"]).to eq("ORD-001")
    expect(result["total"]).to eq(1)
  end
end
