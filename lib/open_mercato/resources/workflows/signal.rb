# frozen_string_literal: true

module OpenMercato
  module Resources
    module Workflows
      class Signal
        class << self
          def send_signal(correlation_key:, signal_name:, payload: {})
            OpenMercato.client.post(
              "/api/workflows/signals",
              { correlationKey: correlation_key, signalName: signal_name, payload: payload }
            )
          end
        end
      end
    end
  end
end
