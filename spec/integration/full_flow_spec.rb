require "spec_helper"
require "open_mercato/testing"

RSpec.describe "Full API flow integration" do
  include OpenMercato::Testing::RequestStubs
  include OpenMercato::Testing::WebhookHelpers

  let(:base_url) { "https://test.open-mercato.local" }

  describe "Catalog: Product lifecycle" do
    it "lists, creates, updates, and deletes a product" do
      # List
      stub_mercato_list("/api/catalog/products",
        items: [OpenMercato::Testing::FakeResponses.product("title" => "Laptop")],
        "total" => 1)

      products = OpenMercato::Resources::Catalog::Product.list
      expect(products.total).to eq(1)
      expect(products.first.title).to eq("Laptop")

      # Create
      stub_mercato_create("/api/catalog/products", response: { "id" => "new-uuid" })
      result = OpenMercato::Resources::Catalog::Product.create(title: "Tablet", sku: "TAB-001")
      expect(result["id"]).to eq("new-uuid")

      # Update
      stub_mercato_update("/api/catalog/products")
      result = OpenMercato::Resources::Catalog::Product.update("new-uuid", title: "Updated Tablet")
      expect(result["ok"]).to be true

      # Delete
      stub_mercato_destroy("/api/catalog/products")
      result = OpenMercato::Resources::Catalog::Product.destroy("new-uuid")
      expect(result["ok"]).to be true
    end
  end

  describe "Sales: Order with lines, payment, shipment" do
    it "creates order flow" do
      # Create order
      stub_mercato_create("/api/sales/orders", response: { "id" => "order-uuid" })
      order = OpenMercato::Resources::Sales::Order.create(
        customer_id: "cust-1", currency_code: "USD"
      )
      expect(order["id"]).to eq("order-uuid")

      # Add line
      stub_mercato_create("/api/sales/order-lines", response: { "id" => "line-uuid" })
      line = OpenMercato::Resources::Sales::OrderLine.create(
        order_id: "order-uuid", variant_id: "var-1", quantity: 2, unit_price: "50.00"
      )
      expect(line["id"]).to eq("line-uuid")

      # Add payment
      stub_mercato_create("/api/sales/payments", response: { "id" => "pay-uuid" })
      payment = OpenMercato::Resources::Sales::Payment.create(
        order_id: "order-uuid", amount: "100.00", currency_code: "USD"
      )
      expect(payment["id"]).to eq("pay-uuid")

      # Add shipment
      stub_mercato_create("/api/sales/shipments", response: { "id" => "ship-uuid" })
      shipment = OpenMercato::Resources::Sales::Shipment.create(
        order_id: "order-uuid", tracking_number: "TRACK-123"
      )
      expect(shipment["id"]).to eq("ship-uuid")
    end
  end

  describe "Quote special actions" do
    it "accepts, converts, and sends quotes" do
      stub_request(:post, "#{base_url}/api/sales/quotes/accept")
        .to_return(status: 200, body: '{"ok":true}', headers: { "Content-Type" => "application/json" })
      expect(OpenMercato::Resources::Sales::Quote.accept("q-1")["ok"]).to be true

      stub_request(:post, "#{base_url}/api/sales/quotes/convert")
        .to_return(status: 200, body: '{"id":"order-from-quote"}', headers: { "Content-Type" => "application/json" })
      expect(OpenMercato::Resources::Sales::Quote.convert_to_order("q-1")["id"]).to eq("order-from-quote")

      stub_request(:post, "#{base_url}/api/sales/quotes/send")
        .to_return(status: 200, body: '{"ok":true}', headers: { "Content-Type" => "application/json" })
      expect(OpenMercato::Resources::Sales::Quote.send_quote("q-1")["ok"]).to be true
    end
  end

  describe "Webhook flow" do
    after { OpenMercato::Webhooks::Handler.clear! }

    it "registers handler and processes event" do
      received_events = []
      OpenMercato::Webhooks::Handler.on("sales.orders.created") { |e| received_events << e }
      OpenMercato::Webhooks::Handler.on("sales.*") { |e| received_events << e }

      event = simulate_mercato_webhook("sales.orders.created", data: { "id" => "order-123", "orderNumber" => "ORD-001" })

      expect(received_events.size).to eq(2)
      expect(received_events.first.record_id).to eq("order-123")
      expect(event).to be_created
    end

    it "generates and verifies signed webhook requests" do
      request = signed_mercato_webhook_request("test.event", data: { "id" => "abc" })

      expect {
        OpenMercato::Webhooks::Signature.verify!(
          payload: request[:payload],
          signature: request[:headers]["X-OpenMercato-Signature"],
          secret: OpenMercato.configuration.webhook_secret
        )
      }.not_to raise_error
    end
  end

  describe "Search" do
    it "performs search and global search" do
      stub_request(:get, "#{base_url}/api/search/search")
        .with(query: hash_including("q" => "laptop"))
        .to_return(status: 200, body: '{"items":[{"id":"1","title":"Laptop"}],"total":1}', headers: { "Content-Type" => "application/json" })

      results = OpenMercato::Resources::Search::Query.search("laptop")
      expect(results["items"].first["title"]).to eq("Laptop")

      stub_request(:get, "#{base_url}/api/search/search/global")
        .with(query: hash_including("q" => "laptop"))
        .to_return(status: 200, body: '{"items":[],"total":0}', headers: { "Content-Type" => "application/json" })

      global = OpenMercato::Resources::Search::Query.global("laptop")
      expect(global["total"]).to eq(0)
    end

    it "triggers reindex" do
      stub_request(:post, "#{base_url}/api/search/reindex")
        .to_return(status: 200, body: '{"ok":true}', headers: { "Content-Type" => "application/json" })

      result = OpenMercato::Resources::Search::Query.reindex
      expect(result["ok"]).to be true
    end
  end

  describe "Workflow signal" do
    it "signals a workflow instance" do
      stub_request(:post, "#{base_url}/api/workflows/instances/inst-1/signal")
        .to_return(status: 200, body: '{"ok":true}', headers: { "Content-Type" => "application/json" })

      result = OpenMercato::Resources::Workflows::Instance.signal("inst-1", "approve", comment: "LGTM")
      expect(result["ok"]).to be true
    end
  end

  describe "Error handling" do
    it "raises ValidationError with field errors" do
      stub_mercato_error("/api/catalog/products",
        status: 400,
        message: "Validation failed",
        field_errors: { "title" => ["can't be blank"] })

      expect {
        OpenMercato::Resources::Catalog::Product.create(title: "")
      }.to raise_error(OpenMercato::ValidationError) { |e|
        expect(e.field_errors["title"]).to include("can't be blank")
      }
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "#{base_url}/api/catalog/products/missing")
        .to_return(status: 404, body: '{"error":"Not found"}', headers: { "Content-Type" => "application/json" })

      expect {
        OpenMercato::Resources::Catalog::Product.find("missing")
      }.to raise_error(OpenMercato::NotFoundError)
    end
  end
end