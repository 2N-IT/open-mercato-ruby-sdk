# frozen_string_literal: true

RSpec.describe OpenMercato::Resource do
  let(:base_url) { "https://test.open-mercato.local" }

  let(:test_resource) do
    Class.new(described_class) do
      api_path "/api/widgets"

      attribute :id, :string
      attribute :name, :string
      attribute :display_name, :string
      attribute :is_active, :boolean
    end
  end

  describe ".api_path" do
    it "stores and retrieves the API path" do
      expect(test_resource.api_path).to eq("/api/widgets")
    end
  end

  describe ".list" do
    before do
      stub_request(:get, "#{base_url}/api/widgets")
        .with(query: { "page" => "1", "pageSize" => "10" })
        .to_return(
          status: 200,
          body: JSON.generate(
            items: [
              { id: "1", name: "Widget A", displayName: "Widget Alpha", isActive: true },
              { id: "2", name: "Widget B", displayName: "Widget Beta", isActive: false }
            ],
            total: 2,
            page: 1,
            pageSize: 10,
            totalPages: 1
          )
        )
    end

    it "returns a Collection" do
      result = test_resource.list(page: 1, page_size: 10)
      expect(result).to be_a(OpenMercato::Collection)
    end

    it "maps items to resource instances" do
      result = test_resource.list(page: 1, page_size: 10)
      expect(result.items.length).to eq(2)
      expect(result.first.name).to eq("Widget A")
    end

    it "transforms camelCase response keys to snake_case" do
      result = test_resource.list(page: 1, page_size: 10)
      expect(result.first.display_name).to eq("Widget Alpha")
      expect(result.first.is_active).to be true
    end
  end

  describe ".find" do
    before do
      stub_request(:get, "#{base_url}/api/widgets/abc-123")
        .to_return(
          status: 200,
          body: JSON.generate(id: "abc-123", name: "Found Widget", displayName: "Found", isActive: true)
        )
    end

    it "returns a resource instance" do
      result = test_resource.find("abc-123")
      expect(result).to be_a(test_resource)
      expect(result.id).to eq("abc-123")
      expect(result.name).to eq("Found Widget")
      expect(result.display_name).to eq("Found")
    end
  end

  describe ".create" do
    before do
      stub_request(:post, "#{base_url}/api/widgets")
        .with(body: '{"name":"New Widget","displayName":"New"}')
        .to_return(status: 201, body: '{"id":"new-123"}')
    end

    it "posts to the API path and returns response" do
      result = test_resource.create(name: "New Widget", display_name: "New")
      expect(result).to eq("id" => "new-123")
    end
  end

  describe ".update" do
    before do
      stub_request(:put, "#{base_url}/api/widgets")
        .with(body: '{"name":"Updated","id":"abc-123"}')
        .to_return(status: 200, body: '{"ok":true}')
    end

    it "sends PUT with id merged into attributes" do
      result = test_resource.update("abc-123", name: "Updated")
      expect(result).to eq("ok" => true)
    end
  end

  describe ".destroy" do
    before do
      stub_request(:delete, "#{base_url}/api/widgets")
        .with(body: '{"id":"abc-123"}')
        .to_return(status: 200, body: '{"ok":true}')
    end

    it "sends DELETE with id" do
      result = test_resource.destroy("abc-123")
      expect(result).to eq("ok" => true)
    end
  end

  describe "attribute initialization" do
    it "converts camelCase keys to snake_case" do
      resource = test_resource.new("displayName" => "Hello", "isActive" => true)
      expect(resource.display_name).to eq("Hello")
      expect(resource.is_active).to be true
    end

    it "accepts snake_case keys" do
      resource = test_resource.new("display_name" => "Hello", "is_active" => true)
      expect(resource.display_name).to eq("Hello")
      expect(resource.is_active).to be true
    end

    it "ignores unknown attributes" do
      resource = test_resource.new("id" => "1", "unknownField" => "ignored")
      expect(resource.id).to eq("1")
    end
  end
end
