module OpenMercato
  module Resources
    module Dictionaries
      class Entry < Resource
        api_path "/api/dictionaries/entries"

        attribute :id, :string
        attribute :dictionary_id, :string
        attribute :label, :string
        attribute :value, :string
        attribute :position, :integer
        attribute :is_active, :boolean
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end