module OpenMercato
  module Resources
    module Sales
      class Invoice < Resource
        api_path "/api/sales/invoices"

        attribute :id, :string
        attribute :invoice_number, :string
        attribute :order_id, :string
        attribute :status, :string
        attribute :customer_id, :string
        attribute :currency_code, :string
        attribute :subtotal, :string
        attribute :tax_total, :string
        attribute :discount_total, :string
        attribute :total, :string
        attribute :issued_at, :string
        attribute :due_date, :string
        attribute :paid_at, :string
        attribute :notes, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end