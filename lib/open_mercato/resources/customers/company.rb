# frozen_string_literal: true

module OpenMercato
  module Resources
    module Customers
      class Company < Resource
        api_path "/api/customers/companies"

        attribute :id, :string
        attribute :name, :string
        attribute :email, :string
        attribute :phone, :string
        attribute :website, :string
        attribute :industry, :string
        attribute :is_active, :boolean
        attribute :tax_id, :string
        attribute :notes, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
