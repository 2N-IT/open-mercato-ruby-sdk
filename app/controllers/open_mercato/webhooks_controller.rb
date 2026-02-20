# frozen_string_literal: true

module OpenMercato
  class WebhooksController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def create
      payload = request.raw_post
      signature = request.headers["X-OpenMercato-Signature"]
      config = OpenMercato.configuration

      Webhooks::Signature.verify!(
        payload: payload,
        signature: signature,
        secret: config.webhook_secret,
        tolerance: config.webhook_tolerance
      )

      parsed = JSON.parse(payload)
      event = Webhooks::Event.new(
        type: parsed["event"],
        data: parsed["data"],
        tenant_id: parsed["tenantId"],
        organization_id: parsed["organizationId"],
        timestamp: parsed["timestamp"]
      )

      if config.async_webhooks
        WebhookJob.perform_later(event.serialize)
      else
        Webhooks::Handler.dispatch(event)
      end

      head :ok
    rescue Webhooks::SignatureError
      head :unauthorized
    rescue JSON::ParserError
      head :bad_request
    rescue StandardError => e
      raise e if config.raise_webhook_errors

      config.logger&.error("[OpenMercato] Webhook processing error: #{e.class}: #{e.message}")
      head :internal_server_error
    end
  end
end
