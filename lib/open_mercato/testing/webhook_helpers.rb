module OpenMercato
  module Testing
    module WebhookHelpers
      def simulate_mercato_webhook(event_type, data: {}, tenant_id: "test-tenant-id", organization_id: "test-org-id")
        event = Webhooks::Event.new(
          type: event_type,
          data: data,
          tenant_id: tenant_id,
          organization_id: organization_id,
          timestamp: Time.now.iso8601
        )
        Webhooks::Handler.dispatch(event)
        event
      end

      def signed_mercato_webhook_request(event_type, data: {}, secret: nil)
        secret ||= OpenMercato.configuration.webhook_secret
        payload = {
          "event" => event_type,
          "data" => data,
          "tenantId" => "test-tenant-id",
          "organizationId" => "test-org-id",
          "timestamp" => Time.now.iso8601
        }.to_json

        timestamp = Time.now.to_i
        sig = Webhooks::Signature.compute(timestamp: timestamp, payload: payload, secret: secret)

        {
          payload: payload,
          headers: {
            "X-OpenMercato-Signature" => "t=#{timestamp},v1=#{sig}",
            "Content-Type" => "application/json"
          }
        }
      end
    end
  end
end