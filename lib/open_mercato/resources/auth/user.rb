# frozen_string_literal: true

module OpenMercato
  module Resources
    module Auth
      class User < Resource
        api_path "/api/auth/users"

        attribute :id, :string
        attribute :email, :string
        attribute :first_name, :string
        attribute :last_name, :string
        attribute :is_active, :boolean
        attribute :role, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
