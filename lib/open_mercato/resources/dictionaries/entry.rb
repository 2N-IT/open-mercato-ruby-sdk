module OpenMercato
  module Resources
    module Dictionaries
      class Entry < Resource
        api_path "/api/dictionaries"

        attribute :id, :string
        attribute :dictionary_id, :string
        attribute :label, :string
        attribute :value, :string
        attribute :position, :integer
        attribute :is_active, :boolean
        attribute :created_at, :string
        attribute :updated_at, :string

        class << self
          def list(dictionary_id, params = {})
            response = OpenMercato.client.get("/api/dictionaries/#{dictionary_id}/entries", params)
            Collection.new(response, self)
          end

          def find(dictionary_id, entry_id)
            response = OpenMercato.client.get("/api/dictionaries/#{dictionary_id}/entries/#{entry_id}")
            new(response)
          end

          def create(dictionary_id, attributes = {})
            OpenMercato.client.post("/api/dictionaries/#{dictionary_id}/entries", attributes)
          end

          def update(dictionary_id, entry_id, attributes = {})
            OpenMercato.client.put("/api/dictionaries/#{dictionary_id}/entries", attributes.merge(id: entry_id))
          end

          def destroy(dictionary_id, entry_id)
            OpenMercato.client.delete("/api/dictionaries/#{dictionary_id}/entries", id: entry_id)
          end
        end
      end
    end
  end
end