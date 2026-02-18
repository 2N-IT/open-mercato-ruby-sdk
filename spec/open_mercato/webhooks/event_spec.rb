# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Webhooks::Event do
  subject(:event) do
    described_class.new(
      type: "sales.orders.created",
      data: { "id" => "uuid-123", "orderNumber" => "ORD-001" },
      tenant_id: "t1",
      organization_id: "o1",
      timestamp: "2026-02-17T14:30:00Z"
    )
  end

  it "parses module/entity/action" do
    expect(event.module_name).to eq("sales")
    expect(event.entity_name).to eq("orders")
    expect(event.action_name).to eq("created")
  end

  it "has convenience predicates" do
    expect(event).to be_created
    expect(event).not_to be_updated
    expect(event).not_to be_deleted
  end

  it "exposes record_id from data" do
    expect(event.record_id).to eq("uuid-123")
  end

  it "serializes and deserializes" do
    restored = described_class.deserialize(event.serialize)
    expect(restored.type).to eq(event.type)
    expect(restored.record_id).to eq(event.record_id)
    expect(restored.tenant_id).to eq("t1")
    expect(restored.organization_id).to eq("o1")
  end

  it "handles missing parts gracefully" do
    short = described_class.new(type: "simple", data: {})
    expect(short.module_name).to eq("simple")
    expect(short.entity_name).to be_nil
    expect(short.action_name).to be_nil
  end
end
