# frozen_string_literal: true

module OpenMercato
  module Webhooks
    class Event
      attr_reader :type, :data, :tenant_id, :organization_id, :timestamp

      def initialize(type:, data:, tenant_id: nil, organization_id: nil, timestamp: nil)
        @type = type
        @data = data || {}
        @tenant_id = tenant_id
        @organization_id = organization_id
        @timestamp = timestamp
      end

      def module_name
        parts[0]
      end

      def entity_name
        parts[1]
      end

      def action_name
        parts[2]
      end

      def record_id
        data["id"]
      end

      def created? = action_name == "created"
      def updated? = action_name == "updated"
      def deleted? = action_name == "deleted"

      def serialize
        {
          "type" => type,
          "data" => data,
          "tenantId" => tenant_id,
          "organizationId" => organization_id,
          "timestamp" => timestamp
        }
      end

      def self.deserialize(hash)
        new(
          type: hash["type"],
          data: hash["data"],
          tenant_id: hash["tenantId"],
          organization_id: hash["organizationId"],
          timestamp: hash["timestamp"]
        )
      end

      private

      def parts
        @parts ||= type.to_s.split(".")
      end
    end
  end
end
