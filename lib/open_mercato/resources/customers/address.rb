# frozen_string_literal: true

module OpenMercato
  module Resources
    module Customers
      class Address < Resource
        api_path "/api/customers/addresses"

        attribute :id, :string
        attribute :addressable_id, :string
        attribute :addressable_type, :string
        attribute :street, :string
        attribute :city, :string
        attribute :state, :string
        attribute :postal_code, :string
        attribute :country_code, :string
        attribute :is_primary, :boolean
        attribute :label, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
