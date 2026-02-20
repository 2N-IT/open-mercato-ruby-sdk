# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Attachments::Library do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/attachments/library")
  end

  it "maps camelCase API response to snake_case attributes" do
    item = described_class.new(
      "id" => "uuid", "fileName" => "doc.pdf", "fileSize" => 1024,
      "mimeType" => "application/pdf", "partitionCode" => "default",
      "partitionTitle" => "Default", "url" => "https://cdn.example.com/doc.pdf"
    )
    expect(item.id).to eq("uuid")
    expect(item.file_name).to eq("doc.pdf")
    expect(item.file_size).to eq(1024)
    expect(item.mime_type).to eq("application/pdf")
    expect(item.partition_code).to eq("default")
    expect(item.url).to eq("https://cdn.example.com/doc.pdf")
  end

  it "lists library items" do
    stub_request(:get, "#{base_url}/api/attachments/library")
      .to_return(
        status: 200,
        body: { items: [{ id: "1", fileName: "doc.pdf" }], total: 1,
                page: 1, pageSize: 25, totalPages: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    items = described_class.list
    expect(items).to be_a(OpenMercato::Collection)
    expect(items.first.file_name).to eq("doc.pdf")
  end
end
