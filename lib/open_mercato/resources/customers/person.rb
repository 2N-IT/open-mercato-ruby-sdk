# frozen_string_literal: true

module OpenMercato
  module Resources
    module Customers
      class Person < Resource
        api_path "/api/customers/people"

        attribute :id, :string
        attribute :first_name, :string
        attribute :last_name, :string
        attribute :email, :string
        attribute :phone, :string
        attribute :company_id, :string
        attribute :is_active, :boolean
        attribute :title, :string
        attribute :notes, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
