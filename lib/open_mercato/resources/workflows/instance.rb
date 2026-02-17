module OpenMercato
  module Resources
    module Workflows
      class Instance < Resource
        api_path "/api/workflows/instances"

        attribute :id, :string
        attribute :definition_id, :string
        attribute :status, :string
        attribute :current_step, :string
        attribute :started_at, :string
        attribute :completed_at, :string
        attribute :created_at, :string
        attribute :updated_at, :string

        class << self
          def signal(id, signal_name, payload = {})
            OpenMercato.client.post("#{api_path}/#{id}/signal", { signal: signal_name }.merge(payload))
          end
        end
      end
    end
  end
end