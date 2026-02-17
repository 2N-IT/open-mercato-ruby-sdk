module OpenMercato
  module Resources
    module Catalog
      class Tag < Resource
        api_path "/api/catalog/tags"

        attribute :id, :string
        attribute :name, :string
        attribute :slug, :string
        attribute :color, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end