# frozen_string_literal: true

require "securerandom"

module OpenMercato
  module Testing
    module FakeResponses
      module_function

      def product(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "title" => "Test Product",
          "sku" => "TEST-001",
          "productType" => "simple",
          "isActive" => true,
          "primaryCurrencyCode" => "USD",
          "description" => "A test product",
          "slug" => "test-product",
          "brand" => "TestBrand",
          "createdAt" => Time.now.iso8601,
          "updatedAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def person(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "firstName" => "John",
          "lastName" => "Doe",
          "email" => "john@example.com",
          "phone" => "+1234567890",
          "isActive" => true,
          "createdAt" => Time.now.iso8601,
          "updatedAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def company(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "name" => "Test Company",
          "email" => "info@testcompany.com",
          "isActive" => true,
          "createdAt" => Time.now.iso8601,
          "updatedAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def order(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "orderNumber" => "ORD-#{rand(1000..9999)}",
          "status" => "pending",
          "currencyCode" => "USD",
          "subtotal" => "100.00",
          "taxTotal" => "10.00",
          "discountTotal" => "0.00",
          "total" => "110.00",
          "createdAt" => Time.now.iso8601,
          "updatedAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def collection(items, overrides = {})
        {
          "items" => items,
          "total" => overrides.fetch("total", items.size),
          "page" => overrides.fetch("page", 1),
          "pageSize" => overrides.fetch("pageSize", 25),
          "totalPages" => overrides.fetch("totalPages", 1)
        }
      end

      def created_response(id = SecureRandom.uuid)
        { "id" => id }
      end

      def ok_response
        { "ok" => true }
      end

      def error_response(message = "Something went wrong", field_errors: {})
        { "error" => message, "fieldErrors" => field_errors, "details" => [] }
      end
    end
  end
end
