module OpenMercato
  module Resources
    module Catalog
      class PriceKind < Resource
        api_path "/api/catalog/price-kinds"

        attribute :id, :string
        attribute :name, :string
        attribute :slug, :string
        attribute :is_default, :boolean
        attribute :priority, :integer
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end