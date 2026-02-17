module OpenMercato
  module Resources
    module Notifications
      class Notification < Resource
        api_path "/api/notifications"

        attribute :id, :string
        attribute :notification_type, :string
        attribute :title, :string
        attribute :body, :string
        attribute :is_read, :boolean
        attribute :recipient_id, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end