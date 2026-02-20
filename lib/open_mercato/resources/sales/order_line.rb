# frozen_string_literal: true

module OpenMercato
  module Resources
    module Sales
      class OrderLine < Resource
        api_path "/api/sales/order-lines"

        attribute :id, :string
        attribute :order_id, :string
        attribute :variant_id, :string
        attribute :quantity, :integer
        attribute :unit_price, :string
        attribute :tax_amount, :string
        attribute :discount_amount, :string
        attribute :total, :string
        attribute :sku, :string
        attribute :title, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
