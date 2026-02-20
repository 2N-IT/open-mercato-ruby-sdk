# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Translations::Translation do
  let(:base_url) { "https://test.open-mercato.local" }
  let(:entity_type) { "products" }
  let(:entity_id) { "prod-uuid" }

  it "fetches translations for an entity" do
    stub_request(:get, "#{base_url}/api/translations/#{entity_type}/#{entity_id}")
      .to_return(
        status: 200,
        body: { "entityType" => entity_type, "entityId" => entity_id,
                "translations" => { "en" => { "title" => "Product" } } }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    result = described_class.find(entity_type, entity_id)
    expect(result["entityType"]).to eq(entity_type)
    expect(result["translations"]["en"]["title"]).to eq("Product")
  end

  it "sets translations for an entity" do
    translations = { "en" => { "title" => "Product" }, "pl" => { "title" => "Produkt" } }
    stub_request(:put, "#{base_url}/api/translations/#{entity_type}/#{entity_id}")
      .to_return(status: 200, body: { "ok" => true }.to_json,
                 headers: { "Content-Type" => "application/json" })

    result = described_class.set_translations(entity_type, entity_id, translations: translations)
    expect(result["ok"]).to be true
  end

  it "deletes translations for an entity" do
    stub_request(:delete, "#{base_url}/api/translations/#{entity_type}/#{entity_id}")
      .to_return(status: 200, body: { "ok" => true }.to_json,
                 headers: { "Content-Type" => "application/json" })

    result = described_class.destroy(entity_type, entity_id)
    expect(result["ok"]).to be true
  end
end
