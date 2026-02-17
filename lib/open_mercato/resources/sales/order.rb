module OpenMercato
  module Resources
    module Sales
      class Order < Resource
        api_path "/api/sales/orders"

        attribute :id, :string
        attribute :order_number, :string
        attribute :status, :string
        attribute :customer_id, :string
        attribute :channel_id, :string
        attribute :currency_code, :string
        attribute :subtotal, :string
        attribute :tax_total, :string
        attribute :discount_total, :string
        attribute :total, :string
        attribute :notes, :string
        attribute :placed_at, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end