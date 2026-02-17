module OpenMercato
  module Resources
    module Catalog
      class Product < Resource
        api_path "/api/catalog/products"

        attribute :id, :string
        attribute :title, :string
        attribute :sku, :string
        attribute :product_type, :string
        attribute :is_active, :boolean
        attribute :primary_currency_code, :string
        attribute :description, :string
        attribute :slug, :string
        attribute :brand, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end