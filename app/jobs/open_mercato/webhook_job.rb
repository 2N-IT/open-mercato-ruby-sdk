module OpenMercato
  class WebhookJob < ActiveJob::Base
    queue_as :open_mercato_webhooks

    def perform(event_data)
      event = Webhooks::Event.deserialize(event_data)
      Webhooks::Handler.dispatch(event)
    end
  end
end