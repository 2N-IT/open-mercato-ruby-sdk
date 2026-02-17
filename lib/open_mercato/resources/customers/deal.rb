module OpenMercato
  module Resources
    module Customers
      class Deal < Resource
        api_path "/api/customers/deals"

        attribute :id, :string
        attribute :title, :string
        attribute :value, :string
        attribute :currency_code, :string
        attribute :stage, :string
        attribute :probability, :integer
        attribute :expected_close_date, :string
        attribute :person_id, :string
        attribute :company_id, :string
        attribute :owner_id, :string
        attribute :is_won, :boolean
        attribute :is_lost, :boolean
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end