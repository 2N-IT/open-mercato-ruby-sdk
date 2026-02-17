require "spec_helper"

RSpec.describe "Catalog resources" do
  {
    OpenMercato::Resources::Catalog::Product => "/api/catalog/products",
    OpenMercato::Resources::Catalog::Variant => "/api/catalog/variants",
    OpenMercato::Resources::Catalog::Price => "/api/catalog/prices",
    OpenMercato::Resources::Catalog::Category => "/api/catalog/categories",
    OpenMercato::Resources::Catalog::Offer => "/api/catalog/offers",
    OpenMercato::Resources::Catalog::PriceKind => "/api/catalog/price-kinds",
    OpenMercato::Resources::Catalog::Tag => "/api/catalog/tags"
  }.each do |klass, expected_path|
    describe klass.name do
      it "has api_path #{expected_path}" do
        expect(klass.api_path).to eq(expected_path)
      end

      it "inherits from Resource" do
        expect(klass.superclass).to eq(OpenMercato::Resource)
      end

      it "defines id attribute" do
        instance = klass.new("id" => "test-id")
        expect(instance.id).to eq("test-id")
      end
    end
  end
end