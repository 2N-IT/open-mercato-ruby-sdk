require "spec_helper"

RSpec.describe "Sales resources" do
  {
    OpenMercato::Resources::Sales::Order => "/api/sales/orders",
    OpenMercato::Resources::Sales::OrderLine => "/api/sales/order-lines",
    OpenMercato::Resources::Sales::Quote => "/api/sales/quotes",
    OpenMercato::Resources::Sales::Payment => "/api/sales/payments",
    OpenMercato::Resources::Sales::Shipment => "/api/sales/shipments",
    OpenMercato::Resources::Sales::Channel => "/api/sales/channels",
    OpenMercato::Resources::Sales::ShippingMethod => "/api/sales/shipping-methods",
    OpenMercato::Resources::Sales::PaymentMethod => "/api/sales/payment-methods",
    OpenMercato::Resources::Sales::TaxRate => "/api/sales/tax-rates"
  }.each do |klass, expected_path|
    describe klass.name do
      it "has api_path #{expected_path}" do
        expect(klass.api_path).to eq(expected_path)
      end

      it "inherits from Resource" do
        expect(klass.superclass).to eq(OpenMercato::Resource)
      end

      it "defines id attribute" do
        instance = klass.new("id" => "test-id")
        expect(instance.id).to eq("test-id")
      end
    end
  end
end