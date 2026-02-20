# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Workflows::Definition do
  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/workflows/definitions")
  end

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  it "instantiates with attributes" do
    definition = described_class.new("id" => "def-1", "name" => "Order Flow", "isActive" => true)
    expect(definition.id).to eq("def-1")
    expect(definition.name).to eq("Order Flow")
    expect(definition.is_active).to be(true)
  end
end
