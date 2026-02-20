# frozen_string_literal: true

module OpenMercato
  module Resources
    module Translations
      # Manages per-entity translation records.
      # Path pattern: /api/translations/:entity_type/:entity_id
      class Translation
        class << self
          def find(entity_type, entity_id)
            OpenMercato.client.get("/api/translations/#{entity_type}/#{entity_id}")
          end

          def set_translations(entity_type, entity_id, translations:)
            OpenMercato.client.put("/api/translations/#{entity_type}/#{entity_id}", translations: translations)
          end

          def destroy(entity_type, entity_id)
            OpenMercato.client.delete("/api/translations/#{entity_type}/#{entity_id}")
          end
        end
      end
    end
  end
end
