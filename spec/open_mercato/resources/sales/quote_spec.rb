require "spec_helper"

RSpec.describe OpenMercato::Resources::Sales::Quote do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/sales/quotes")
  end

  it "defines expected attributes" do
    quote = described_class.new(
      "id" => "uuid", "quoteNumber" => "QUO-001", "status" => "draft",
      "customerId" => "cust-1", "currencyCode" => "PLN",
      "total" => "500.00", "validUntil" => "2026-03-01"
    )
    expect(quote.id).to eq("uuid")
    expect(quote.quote_number).to eq("QUO-001")
    expect(quote.status).to eq("draft")
    expect(quote.total).to eq("500.00")
    expect(quote.valid_until).to eq("2026-03-01")
  end

  describe ".accept" do
    it "posts to accept endpoint" do
      stub_request(:post, "#{base_url}/api/sales/quotes/accept")
        .with(body: { id: "q-1" }.to_json)
        .to_return(
          status: 200,
          body: { success: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.accept("q-1")
      expect(result).to eq({ "success" => true })
    end
  end

  describe ".convert_to_order" do
    it "posts to convert endpoint" do
      stub_request(:post, "#{base_url}/api/sales/quotes/convert")
        .with(body: { id: "q-1" }.to_json)
        .to_return(
          status: 200,
          body: { orderId: "ord-1" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.convert_to_order("q-1")
      expect(result).to eq({ "orderId" => "ord-1" })
    end
  end

  describe ".send_quote" do
    it "posts to send endpoint" do
      stub_request(:post, "#{base_url}/api/sales/quotes/send")
        .with(body: { id: "q-1" }.to_json)
        .to_return(
          status: 200,
          body: { sent: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.send_quote("q-1")
      expect(result).to eq({ "sent" => true })
    end
  end
end