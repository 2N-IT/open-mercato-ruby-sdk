# frozen_string_literal: true

require "spec_helper"
require "open_mercato/testing"

RSpec.describe OpenMercato::Testing::FakeResponses do
  describe ".product" do
    it "returns hash with expected keys" do
      product = described_class.product
      expect(product).to include("id", "title", "sku", "productType", "isActive")
    end

    it "accepts overrides" do
      product = described_class.product("title" => "Custom")
      expect(product["title"]).to eq("Custom")
    end
  end

  describe ".person" do
    it "returns hash with expected keys" do
      person = described_class.person
      expect(person).to include("id", "firstName", "lastName", "email")
    end
  end

  describe ".company" do
    it "returns hash with expected keys" do
      company = described_class.company
      expect(company).to include("id", "name", "email", "isActive")
    end
  end

  describe ".order" do
    it "returns hash with expected keys" do
      order = described_class.order
      expect(order).to include("id", "orderNumber", "status", "total")
    end
  end

  describe ".collection" do
    it "wraps items with pagination" do
      items = [described_class.product, described_class.product]
      result = described_class.collection(items)
      expect(result["items"]).to eq(items)
      expect(result["total"]).to eq(2)
      expect(result["page"]).to eq(1)
    end

    it "allows pagination overrides" do
      result = described_class.collection([], "total" => 100, "page" => 3)
      expect(result["total"]).to eq(100)
      expect(result["page"]).to eq(3)
    end
  end

  describe ".created_response" do
    it "returns id" do
      expect(described_class.created_response("abc")["id"]).to eq("abc")
    end
  end

  describe ".ok_response" do
    it "returns ok: true" do
      expect(described_class.ok_response["ok"]).to be true
    end
  end

  describe ".error_response" do
    it "returns error structure" do
      response = described_class.error_response("Bad request", field_errors: { "name" => "required" })
      expect(response["error"]).to eq("Bad request")
      expect(response["fieldErrors"]).to eq("name" => "required")
    end
  end
end
