module OpenMercato
  module Resources
    module Auth
      class ApiKey < Resource
        api_path "/api/api_keys/keys"

        attribute :id, :string
        attribute :name, :string
        attribute :key_prefix, :string
        attribute :is_active, :boolean
        attribute :expires_at, :string
        attribute :last_used_at, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end