# frozen_string_literal: true

module OpenMercato
  module Resources
    module Catalog
      class Offer < Resource
        api_path "/api/catalog/offers"

        attribute :id, :string
        attribute :variant_id, :string
        attribute :channel_id, :string
        attribute :price, :string
        attribute :currency_code, :string
        attribute :stock_quantity, :integer
        attribute :is_active, :boolean
        attribute :valid_from, :string
        attribute :valid_to, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
