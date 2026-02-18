# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Catalog::Product do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/catalog/products")
  end

  it "defines expected attributes" do
    product = described_class.new(
      "id" => "uuid", "title" => "Laptop", "sku" => "LAP-001",
      "productType" => "simple", "isActive" => true, "primaryCurrencyCode" => "PLN"
    )
    expect(product.id).to eq("uuid")
    expect(product.title).to eq("Laptop")
    expect(product.sku).to eq("LAP-001")
    expect(product.product_type).to eq("simple")
    expect(product.is_active).to be true
    expect(product.primary_currency_code).to eq("PLN")
  end

  it "lists products" do
    stub_request(:get, "#{base_url}/api/catalog/products")
      .to_return(
        status: 200,
        body: { items: [{ id: "1", title: "A" }], total: 1, page: 1, pageSize: 25, totalPages: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
    products = described_class.list
    expect(products).to be_a(OpenMercato::Collection)
    expect(products.first.title).to eq("A")
  end
end
