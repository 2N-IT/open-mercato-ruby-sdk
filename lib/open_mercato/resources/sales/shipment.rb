module OpenMercato
  module Resources
    module Sales
      class Shipment < Resource
        api_path "/api/sales/shipments"

        attribute :id, :string
        attribute :order_id, :string
        attribute :status, :string
        attribute :shipping_method_id, :string
        attribute :tracking_number, :string
        attribute :tracking_url, :string
        attribute :shipped_at, :string
        attribute :delivered_at, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end