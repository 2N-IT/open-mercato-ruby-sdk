module OpenMercato
  module Resources
    module Search
      class Query
        class << self
          def search(query, params = {})
            OpenMercato.client.get("/api/search/search", params.merge(q: query))
          end

          def global(query, params = {})
            OpenMercato.client.get("/api/search/search/global", params.merge(q: query))
          end

          def reindex(params = {})
            OpenMercato.client.post("/api/search/reindex", params)
          end
        end
      end
    end
  end
end