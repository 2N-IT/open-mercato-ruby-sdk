module OpenMercato
  module Resources
    module Catalog
      class Category < Resource
        api_path "/api/catalog/categories"

        attribute :id, :string
        attribute :name, :string
        attribute :slug, :string
        attribute :parent_id, :string
        attribute :position, :integer
        attribute :is_active, :boolean
        attribute :description, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end