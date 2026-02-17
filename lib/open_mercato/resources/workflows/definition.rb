module OpenMercato
  module Resources
    module Workflows
      class Definition < Resource
        api_path "/api/workflows/definitions"

        attribute :id, :string
        attribute :name, :string
        attribute :description, :string
        attribute :is_active, :boolean
        attribute :trigger_event, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end