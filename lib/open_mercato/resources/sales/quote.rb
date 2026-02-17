module OpenMercato
  module Resources
    module Sales
      class Quote < Resource
        api_path "/api/sales/quotes"

        attribute :id, :string
        attribute :quote_number, :string
        attribute :status, :string
        attribute :customer_id, :string
        attribute :channel_id, :string
        attribute :currency_code, :string
        attribute :subtotal, :string
        attribute :tax_total, :string
        attribute :discount_total, :string
        attribute :total, :string
        attribute :valid_until, :string
        attribute :notes, :string
        attribute :created_at, :string
        attribute :updated_at, :string

        class << self
          def accept(id)
            OpenMercato.client.post("#{api_path}/accept", id: id)
          end

          def convert_to_order(id)
            OpenMercato.client.post("#{api_path}/convert", id: id)
          end

          def send_quote(id)
            OpenMercato.client.post("#{api_path}/send", id: id)
          end
        end
      end
    end
  end
end