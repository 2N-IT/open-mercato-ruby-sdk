RSpec.describe OpenMercato::Collection do
  let(:resource_class) do
    Class.new(OpenMercato::Resource) do
      attribute :id, :string
      attribute :name, :string
    end
  end

  let(:response) do
    {
      "items" => [
        { "id" => "1", "name" => "First" },
        { "id" => "2", "name" => "Second" }
      ],
      "total" => 50,
      "page" => 2,
      "pageSize" => 25,
      "totalPages" => 2
    }
  end

  subject(:collection) { described_class.new(response, resource_class) }

  describe "#items" do
    it "maps response items to resource instances" do
      expect(collection.items.length).to eq(2)
      expect(collection.items.first).to be_a(resource_class)
      expect(collection.items.first.id).to eq("1")
      expect(collection.items.first.name).to eq("First")
    end
  end

  describe "pagination attributes" do
    it "reads total from response" do
      expect(collection.total).to eq(50)
    end

    it "reads page from response" do
      expect(collection.page).to eq(2)
    end

    it "reads page_size from response" do
      expect(collection.page_size).to eq(25)
    end

    it "reads total_pages from response" do
      expect(collection.total_pages).to eq(2)
    end
  end

  describe "defaults" do
    subject(:collection) { described_class.new({}, resource_class) }

    it "defaults total to 0" do
      expect(collection.total).to eq(0)
    end

    it "defaults page to 1" do
      expect(collection.page).to eq(1)
    end

    it "defaults page_size to 25" do
      expect(collection.page_size).to eq(25)
    end

    it "defaults total_pages to 1" do
      expect(collection.total_pages).to eq(1)
    end

    it "defaults items to empty array" do
      expect(collection.items).to eq([])
    end
  end

  describe "#each" do
    it "is Enumerable" do
      expect(collection).to be_a(Enumerable)
    end

    it "iterates over items" do
      names = collection.map(&:name)
      expect(names).to eq(%w[First Second])
    end
  end

  describe "#next_page?" do
    it "returns true when more pages exist" do
      col = described_class.new({ "page" => 1, "totalPages" => 3 }, resource_class)
      expect(col.next_page?).to be true
    end

    it "returns false on last page" do
      col = described_class.new({ "page" => 3, "totalPages" => 3 }, resource_class)
      expect(col.next_page?).to be false
    end
  end

  describe "#prev_page?" do
    it "returns true when not on first page" do
      col = described_class.new({ "page" => 2, "totalPages" => 3 }, resource_class)
      expect(col.prev_page?).to be true
    end

    it "returns false on first page" do
      col = described_class.new({ "page" => 1, "totalPages" => 3 }, resource_class)
      expect(col.prev_page?).to be false
    end
  end
end
