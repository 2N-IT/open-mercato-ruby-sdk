# frozen_string_literal: true

module OpenMercato
  module Resources
    module Sales
      class TaxRate < Resource
        api_path "/api/sales/tax-rates"

        attribute :id, :string
        attribute :name, :string
        attribute :rate, :string
        attribute :is_active, :boolean
        attribute :country_code, :string
        attribute :description, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
