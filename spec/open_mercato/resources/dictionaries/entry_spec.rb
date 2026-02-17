require "spec_helper"

RSpec.describe OpenMercato::Resources::Dictionaries::Entry do
  let(:base_url) { "https://test.open-mercato.local" }
  let(:dictionary_id) { "dict-1" }

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  describe ".list" do
    it "fetches entries nested under a dictionary" do
      stub_request(:get, "#{base_url}/api/dictionaries/#{dictionary_id}/entries")
        .to_return(status: 200, body: '{"items": [{"id": "entry-1", "label": "Active"}], "total": 1}')

      result = described_class.list(dictionary_id)
      expect(result).to be_a(OpenMercato::Collection)
    end

    it "passes query params" do
      stub_request(:get, "#{base_url}/api/dictionaries/#{dictionary_id}/entries")
        .with(query: { "pageSize" => "10" })
        .to_return(status: 200, body: '{"items": [], "total": 0}')

      described_class.list(dictionary_id, page_size: 10)
    end
  end

  describe ".find" do
    it "fetches a single entry nested under a dictionary" do
      stub_request(:get, "#{base_url}/api/dictionaries/#{dictionary_id}/entries/entry-1")
        .to_return(status: 200, body: '{"id": "entry-1", "label": "Active", "value": "active"}')

      entry = described_class.find(dictionary_id, "entry-1")
      expect(entry.id).to eq("entry-1")
      expect(entry.label).to eq("Active")
      expect(entry.value).to eq("active")
    end
  end

  describe ".create" do
    it "posts to the nested entries path" do
      stub_request(:post, "#{base_url}/api/dictionaries/#{dictionary_id}/entries")
        .with(body: '{"label":"New Entry","value":"new"}')
        .to_return(status: 201, body: '{"id": "entry-2"}')

      described_class.create(dictionary_id, label: "New Entry", value: "new")
    end
  end

  describe ".update" do
    it "puts to the nested entries path with id in body" do
      stub_request(:put, "#{base_url}/api/dictionaries/#{dictionary_id}/entries")
        .with(body: '{"label":"Updated","id":"entry-1"}')
        .to_return(status: 200, body: '{"ok": true}')

      described_class.update(dictionary_id, "entry-1", label: "Updated")
    end
  end

  describe ".destroy" do
    it "deletes via the nested entries path with id in body" do
      stub_request(:delete, "#{base_url}/api/dictionaries/#{dictionary_id}/entries")
        .with(body: '{"id":"entry-1"}')
        .to_return(status: 200, body: '{"ok": true}')

      described_class.destroy(dictionary_id, "entry-1")
    end
  end
end