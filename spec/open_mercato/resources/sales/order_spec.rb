# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Sales::Order do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/sales/orders")
  end

  it "defines expected attributes" do
    order = described_class.new(
      "id" => "uuid", "orderNumber" => "ORD-001", "status" => "pending",
      "customerId" => "cust-1", "channelId" => "ch-1", "currencyCode" => "PLN",
      "subtotal" => "100.00", "taxTotal" => "23.00", "discountTotal" => "0.00",
      "total" => "123.00", "placedAt" => "2026-01-15"
    )
    expect(order.id).to eq("uuid")
    expect(order.order_number).to eq("ORD-001")
    expect(order.status).to eq("pending")
    expect(order.customer_id).to eq("cust-1")
    expect(order.currency_code).to eq("PLN")
    expect(order.subtotal).to eq("100.00")
    expect(order.total).to eq("123.00")
    expect(order.placed_at).to eq("2026-01-15")
  end

  it "lists orders" do
    stub_request(:get, "#{base_url}/api/sales/orders")
      .to_return(
        status: 200,
        body: { items: [{ id: "1", orderNumber: "ORD-001" }], total: 1, page: 1, pageSize: 25, totalPages: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
    orders = described_class.list
    expect(orders).to be_a(OpenMercato::Collection)
    expect(orders.first.order_number).to eq("ORD-001")
  end
end
