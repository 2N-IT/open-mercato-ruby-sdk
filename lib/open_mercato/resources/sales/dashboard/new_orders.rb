# frozen_string_literal: true

module OpenMercato
  module Resources
    module Sales
      module Dashboard
        class NewOrders
          class << self
            # Params: limit (1-20), date_period (last24h|last7d|last30d|custom),
            #         custom_from, custom_to (ISO strings when date_period=custom)
            def list(params = {})
              OpenMercato.client.get("/api/sales/dashboard/widgets/new-orders", params)
            end
          end
        end
      end
    end
  end
end
