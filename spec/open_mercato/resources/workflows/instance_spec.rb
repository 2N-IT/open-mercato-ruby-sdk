# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Workflows::Instance do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/workflows/instances")
  end

  it "defines expected attributes" do
    instance = described_class.new(
      "id" => "uuid", "definitionId" => "def-1", "status" => "running",
      "currentStep" => "approval", "startedAt" => "2026-01-15"
    )
    expect(instance.id).to eq("uuid")
    expect(instance.definition_id).to eq("def-1")
    expect(instance.status).to eq("running")
    expect(instance.current_step).to eq("approval")
    expect(instance.started_at).to eq("2026-01-15")
  end

  describe ".signal" do
    it "posts a signal to a workflow instance" do
      stub_request(:post, "#{base_url}/api/workflows/instances/wf-1/signal")
        .with(body: { signal: "approve", comment: "Looks good" }.to_json)
        .to_return(
          status: 200,
          body: { success: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.signal("wf-1", "approve", comment: "Looks good")
      expect(result["success"]).to be true
    end
  end
end
