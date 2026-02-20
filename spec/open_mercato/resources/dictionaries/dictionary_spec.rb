# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Dictionaries::Dictionary do
  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/dictionaries")
  end

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  it "instantiates with attributes" do
    dictionary = described_class.new("id" => "dict-1", "name" => "Countries", "slug" => "countries")
    expect(dictionary.id).to eq("dict-1")
    expect(dictionary.name).to eq("Countries")
    expect(dictionary.slug).to eq("countries")
  end
end
