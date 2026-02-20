# frozen_string_literal: true

module OpenMercato
  module Resources
    module Workflows
      class Task < Resource
        api_path "/api/workflows/tasks"

        attribute :id,                   :string
        attribute :title,                :string
        attribute :description,          :string
        attribute :status,               :string
        attribute :assigned_to,          :string
        attribute :workflow_instance_id, :string
        attribute :due_date,             :string
        attribute :created_at,           :string
        attribute :updated_at,           :string

        class << self
          def claim(id)
            OpenMercato.client.post("#{api_path}/#{id}/claim")
          end

          def complete(id, form_data: {}, comments: nil)
            payload = { formData: form_data }
            payload[:comments] = comments if comments
            OpenMercato.client.post("#{api_path}/#{id}/complete", payload)
          end
        end
      end
    end
  end
end
