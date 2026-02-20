# frozen_string_literal: true

require "active_model"

module OpenMercato
  class Resource
    include ActiveModel::Model
    include ActiveModel::Attributes

    class << self
      def api_path(path = nil)
        if path
          @api_path = path
        else
          @api_path
        end
      end

      def list(params = {})
        response = client.get(api_path, params)
        Collection.new(response, self)
      end

      def find(id)
        response = client.get("#{api_path}/#{id}")
        new(response)
      end

      def create(attributes = {})
        client.post(api_path, attributes)
      end

      def update(id, attributes = {})
        client.put(api_path, attributes.merge(id: id))
      end

      def destroy(id)
        client.delete(api_path, id: id)
      end

      private

      def client
        OpenMercato.client
      end
    end

    def initialize(attributes = {})
      sanitized = attributes.each_with_object({}) do |(key, value), hash|
        snake_key = key.to_s.gsub(/([A-Z])/) { "_#{::Regexp.last_match(1).downcase}" }.to_sym
        hash[snake_key] = value if self.class.attribute_names.include?(snake_key.to_s)
      end
      super(sanitized)
    end
  end
end
