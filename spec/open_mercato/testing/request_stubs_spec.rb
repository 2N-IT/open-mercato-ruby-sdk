require "spec_helper"
require "open_mercato/testing"

RSpec.describe OpenMercato::Testing::RequestStubs do
  include described_class

  describe "#stub_mercato_list" do
    it "stubs a list endpoint" do
      items = [OpenMercato::Testing::FakeResponses.product]
      stub_mercato_list("/api/catalog/products", items: items)

      products = OpenMercato::Resources::Catalog::Product.list
      expect(products).to be_a(OpenMercato::Collection)
      expect(products.first.title).to eq("Test Product")
    end
  end

  describe "#stub_mercato_create" do
    it "stubs a create endpoint" do
      stub_mercato_create("/api/catalog/products")

      result = OpenMercato::Resources::Catalog::Product.create(title: "New")
      expect(result["id"]).to be_a(String)
    end
  end

  describe "#stub_mercato_update" do
    it "stubs an update endpoint" do
      stub_mercato_update("/api/catalog/products")

      result = OpenMercato::Resources::Catalog::Product.update("uuid", title: "Updated")
      expect(result["ok"]).to be true
    end
  end

  describe "#stub_mercato_destroy" do
    it "stubs a destroy endpoint" do
      stub_mercato_destroy("/api/catalog/products")

      result = OpenMercato::Resources::Catalog::Product.destroy("uuid")
      expect(result["ok"]).to be true
    end
  end

  describe "#stub_mercato_error" do
    it "stubs an error response" do
      stub_mercato_error("/api/catalog/products", status: 400, message: "Invalid")

      expect {
        OpenMercato::Resources::Catalog::Product.list
      }.to raise_error(OpenMercato::Error)
    end
  end
end