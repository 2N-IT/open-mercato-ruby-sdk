require "openssl"

module OpenMercato
  module Webhooks
    class SignatureError < OpenMercato::Error; end

    class Signature
      class << self
        def compute(timestamp:, payload:, secret:)
          signed_payload = "#{timestamp}.#{payload}"
          OpenSSL::HMAC.hexdigest("SHA256", secret, signed_payload)
        end

        def verify!(payload:, signature:, secret:, tolerance: nil)
          raise SignatureError, "No signature provided" if signature.nil? || signature.empty?
          raise SignatureError, "No webhook secret configured" if secret.nil? || secret.empty?

          timestamp, received_sig = parse_header(signature)
          expected_sig = compute(timestamp: timestamp, payload: payload, secret: secret)

          unless secure_compare(expected_sig, received_sig)
            raise SignatureError, "Signature mismatch"
          end

          if tolerance && (Time.now.to_i - timestamp.to_i) > tolerance
            raise SignatureError, "Timestamp too old (older than #{tolerance}s)"
          end

          true
        end

        private

        def parse_header(header)
          parts = header.split(",").each_with_object({}) do |part, hash|
            key, value = part.split("=", 2)
            hash[key.strip] = value
          end

          timestamp = parts["t"]
          sig = parts["v1"]
          raise SignatureError, "Invalid signature format" unless timestamp && sig

          [timestamp, sig]
        end

        def secure_compare(a, b)
          return false unless a.bytesize == b.bytesize
          OpenSSL.fixed_length_secure_compare(a, b)
        end
      end
    end
  end
end