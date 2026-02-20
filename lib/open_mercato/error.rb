# frozen_string_literal: true

module OpenMercato
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class ForbiddenError < Error; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end

  class ValidationError < Error
    attr_reader :field_errors, :details

    def initialize(message = nil, field_errors: {}, details: nil)
      @field_errors = field_errors
      @details = details
      super(message || build_message)
    end

    def self.from_response(body)
      new(
        body["error"],
        field_errors: body["fieldErrors"] || {},
        details: body["details"]
      )
    end

    private

    def build_message
      return "Validation failed" if field_errors.empty?

      errors = field_errors.map { |field, msgs| "#{field}: #{Array(msgs).join(', ')}" }
      "Validation failed: #{errors.join('; ')}"
    end
  end
end
