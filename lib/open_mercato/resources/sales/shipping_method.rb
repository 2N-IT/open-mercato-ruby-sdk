# frozen_string_literal: true

module OpenMercato
  module Resources
    module Sales
      class ShippingMethod < Resource
        api_path "/api/sales/shipping-methods"

        attribute :id, :string
        attribute :name, :string
        attribute :slug, :string
        attribute :price, :string
        attribute :currency_code, :string
        attribute :is_active, :boolean
        attribute :description, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
