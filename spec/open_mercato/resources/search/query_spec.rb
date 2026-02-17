require "spec_helper"

RSpec.describe OpenMercato::Resources::Search::Query do
  let(:base_url) { "https://test.open-mercato.local" }

  describe ".search" do
    it "sends a search request with query parameter" do
      stub_request(:get, "#{base_url}/api/search/search")
        .with(query: { q: "laptop", page: 1 })
        .to_return(
          status: 200,
          body: { results: [{ id: "1", title: "Laptop" }], total: 1 }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.search("laptop", page: 1)
      expect(result["results"].first["title"]).to eq("Laptop")
    end
  end

  describe ".global" do
    it "sends a global search request" do
      stub_request(:get, "#{base_url}/api/search/search/global")
        .with(query: { q: "test" })
        .to_return(
          status: 200,
          body: { results: [], total: 0 }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.global("test")
      expect(result["total"]).to eq(0)
    end
  end

  describe ".reindex" do
    it "posts a reindex request" do
      stub_request(:post, "#{base_url}/api/search/reindex")
        .with(body: { entityType: "products" }.to_json)
        .to_return(
          status: 200,
          body: { success: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
      result = described_class.reindex(entity_type: "products")
      expect(result["success"]).to be true
    end
  end
end