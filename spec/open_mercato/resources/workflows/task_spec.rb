# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Workflows::Task do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/workflows/tasks")
  end

  it "maps camelCase API response to snake_case attributes" do
    task = described_class.new(
      "id" => "uuid", "title" => "Review order",
      "status" => "PENDING", "assignedTo" => "user-id",
      "workflowInstanceId" => "wf-id"
    )
    expect(task.id).to eq("uuid")
    expect(task.title).to eq("Review order")
    expect(task.status).to eq("PENDING")
    expect(task.assigned_to).to eq("user-id")
    expect(task.workflow_instance_id).to eq("wf-id")
  end

  it "claims a task" do
    stub_request(:post, "#{base_url}/api/workflows/tasks/task-1/claim")
      .to_return(status: 200, body: { data: { id: "task-1", status: "IN_PROGRESS" } }.to_json,
                 headers: { "Content-Type" => "application/json" })

    result = described_class.claim("task-1")
    expect(result).to be_a(Hash)
  end

  it "completes a task with form data" do
    stub_request(:post, "#{base_url}/api/workflows/tasks/task-1/complete")
      .to_return(status: 200, body: { data: { id: "task-1", status: "COMPLETED" } }.to_json,
                 headers: { "Content-Type" => "application/json" })

    result = described_class.complete("task-1", form_data: { approved: true }, comments: "OK")
    expect(result).to be_a(Hash)
  end
end
