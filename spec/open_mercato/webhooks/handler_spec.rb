# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Webhooks::Handler do
  after { described_class.clear! }

  it "dispatches to exact match" do
    received = nil
    described_class.on("sales.orders.created") { |e| received = e }

    event = OpenMercato::Webhooks::Event.new(type: "sales.orders.created", data: { "id" => "1" })
    described_class.dispatch(event)

    expect(received).to eq(event)
  end

  it "dispatches to wildcard match" do
    received = []
    described_class.on("sales.*") { |e| received << e.type }

    described_class.dispatch(OpenMercato::Webhooks::Event.new(type: "sales.orders.created", data: {}))
    described_class.dispatch(OpenMercato::Webhooks::Event.new(type: "catalog.products.updated", data: {}))

    expect(received).to eq(["sales.orders.created"])
  end

  it "dispatches to catch-all *" do
    count = 0
    described_class.on("*") { |_| count += 1 }

    described_class.dispatch(OpenMercato::Webhooks::Event.new(type: "any.event.here", data: {}))
    expect(count).to eq(1)
  end

  it "dispatches to multiple handlers" do
    results = []
    described_class.on("test.event") { results << :a }
    described_class.on("test.event") { results << :b }

    described_class.dispatch(OpenMercato::Webhooks::Event.new(type: "test.event", data: {}))
    expect(results).to eq(%i[a b])
  end

  it "accepts callable objects" do
    handler = double("handler")
    expect(handler).to receive(:call).once

    described_class.on("test.event", handler)
    described_class.dispatch(OpenMercato::Webhooks::Event.new(type: "test.event", data: {}))
  end

  it "raises without handler or block" do
    expect { described_class.on("test") }.to raise_error(ArgumentError)
  end
end
