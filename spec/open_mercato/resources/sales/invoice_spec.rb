require "spec_helper"

RSpec.describe OpenMercato::Resources::Sales::Invoice do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has api_path /api/sales/invoices" do
    expect(described_class.api_path).to eq("/api/sales/invoices")
  end

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  describe "attributes" do
    subject(:invoice) do
      described_class.new(
        "id" => "inv-1",
        "invoiceNumber" => "INV-001",
        "orderId" => "order-1",
        "status" => "issued",
        "customerId" => "cust-1",
        "currencyCode" => "USD",
        "subtotal" => "100.00",
        "taxTotal" => "10.00",
        "discountTotal" => "5.00",
        "total" => "105.00",
        "issuedAt" => "2026-01-01T00:00:00Z",
        "dueDate" => "2026-02-01",
        "paidAt" => nil,
        "notes" => "Test invoice"
      )
    end

    it "maps all attributes" do
      expect(invoice.id).to eq("inv-1")
      expect(invoice.invoice_number).to eq("INV-001")
      expect(invoice.order_id).to eq("order-1")
      expect(invoice.status).to eq("issued")
      expect(invoice.customer_id).to eq("cust-1")
      expect(invoice.currency_code).to eq("USD")
      expect(invoice.subtotal).to eq("100.00")
      expect(invoice.tax_total).to eq("10.00")
      expect(invoice.discount_total).to eq("5.00")
      expect(invoice.total).to eq("105.00")
      expect(invoice.issued_at).to eq("2026-01-01T00:00:00Z")
      expect(invoice.due_date).to eq("2026-02-01")
      expect(invoice.paid_at).to be_nil
      expect(invoice.notes).to eq("Test invoice")
    end
  end

  describe ".list" do
    it "fetches invoices" do
      stub_request(:get, "#{base_url}/api/sales/invoices")
        .to_return(status: 200, body: '{"items": [{"id": "inv-1"}], "total": 1}')

      result = described_class.list
      expect(result).to be_a(OpenMercato::Collection)
    end
  end

  describe ".find" do
    it "fetches a single invoice" do
      stub_request(:get, "#{base_url}/api/sales/invoices/inv-1")
        .to_return(status: 200, body: '{"id": "inv-1", "invoiceNumber": "INV-001"}')

      invoice = described_class.find("inv-1")
      expect(invoice.id).to eq("inv-1")
      expect(invoice.invoice_number).to eq("INV-001")
    end
  end
end