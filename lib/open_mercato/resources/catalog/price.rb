# frozen_string_literal: true

module OpenMercato
  module Resources
    module Catalog
      class Price < Resource
        api_path "/api/catalog/prices"

        attribute :id, :string
        attribute :variant_id, :string
        attribute :price_kind_id, :string
        attribute :amount, :string
        attribute :currency_code, :string
        attribute :min_quantity, :integer
        attribute :valid_from, :string
        attribute :valid_to, :string
        attribute :channel_id, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
