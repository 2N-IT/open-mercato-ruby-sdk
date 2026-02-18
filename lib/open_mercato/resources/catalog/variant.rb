# frozen_string_literal: true

module OpenMercato
  module Resources
    module Catalog
      class Variant < Resource
        api_path "/api/catalog/variants"

        attribute :id, :string
        attribute :product_id, :string
        attribute :title, :string
        attribute :sku, :string
        attribute :barcode, :string
        attribute :is_active, :boolean
        attribute :position, :integer
        attribute :weight, :string
        attribute :width, :string
        attribute :height, :string
        attribute :depth, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
