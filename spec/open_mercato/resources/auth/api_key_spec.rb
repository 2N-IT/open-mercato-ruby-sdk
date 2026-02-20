# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Auth::ApiKey do
  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/api_keys/keys")
  end

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  it "instantiates with attributes" do
    api_key = described_class.new(
      "id" => "key-1",
      "name" => "Production Key",
      "keyPrefix" => "omk_prod",
      "isActive" => true
    )
    expect(api_key.id).to eq("key-1")
    expect(api_key.name).to eq("Production Key")
    expect(api_key.key_prefix).to eq("omk_prod")
    expect(api_key.is_active).to be(true)
  end
end
