module OpenMercato
  module Resources
    module Customers
      class Activity < Resource
        api_path "/api/customers/activities"

        attribute :id, :string
        attribute :activity_type, :string
        attribute :subject, :string
        attribute :description, :string
        attribute :due_date, :string
        attribute :is_done, :boolean
        attribute :person_id, :string
        attribute :company_id, :string
        attribute :deal_id, :string
        attribute :owner_id, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end