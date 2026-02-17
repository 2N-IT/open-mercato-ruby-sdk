module OpenMercato
  module Resources
    module Sales
      class Channel < Resource
        api_path "/api/sales/channels"

        attribute :id, :string
        attribute :name, :string
        attribute :slug, :string
        attribute :is_active, :boolean
        attribute :description, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end