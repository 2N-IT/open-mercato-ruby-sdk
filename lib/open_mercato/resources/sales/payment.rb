module OpenMercato
  module Resources
    module Sales
      class Payment < Resource
        api_path "/api/sales/payments"

        attribute :id, :string
        attribute :order_id, :string
        attribute :amount, :string
        attribute :currency_code, :string
        attribute :status, :string
        attribute :payment_method_id, :string
        attribute :reference, :string
        attribute :paid_at, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end