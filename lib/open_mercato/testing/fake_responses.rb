# frozen_string_literal: true

require "securerandom"

module OpenMercato
  module Testing
    module FakeResponses # rubocop:disable Metrics/ModuleLength
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

      def workflow_task(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "title" => "Review order",
          "description" => "Please review and approve the order",
          "status" => "PENDING",
          "assignedTo" => SecureRandom.uuid,
          "workflowInstanceId" => SecureRandom.uuid,
          "dueDate" => Time.now.iso8601,
          "createdAt" => Time.now.iso8601,
          "updatedAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def translation(overrides = {})
        {
          "entityType" => "products",
          "entityId" => SecureRandom.uuid,
          "translations" => { "en" => { "title" => "Product" }, "pl" => { "title" => "Produkt" } },
          "createdAt" => Time.now.iso8601,
          "updatedAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def attachment_library_item(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "fileName" => "document.pdf",
          "fileSize" => 102_400,
          "mimeType" => "application/pdf",
          "partitionCode" => "default",
          "partitionTitle" => "Default",
          "url" => "https://cdn.example.com/document.pdf",
          "thumbnailUrl" => nil,
          "tags" => [],
          "content" => nil,
          "createdAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def sales_widget_order(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "orderNumber" => "ORD-#{rand(1000..9999)}",
          "status" => "pending",
          "fulfillmentStatus" => "unfulfilled",
          "paymentStatus" => "unpaid",
          "customerName" => "John Doe",
          "customerEntityId" => SecureRandom.uuid,
          "netAmount" => "100.00",
          "grossAmount" => "123.00",
          "currency" => "USD",
          "createdAt" => Time.now.iso8601
        }.merge(overrides)
      end

      def sales_widget_quote(overrides = {})
        {
          "id" => SecureRandom.uuid,
          "quoteNumber" => "QUO-#{rand(1000..9999)}",
          "status" => "draft",
          "customerName" => "Jane Smith",
          "customerEntityId" => SecureRandom.uuid,
          "validFrom" => Time.now.iso8601,
          "validUntil" => Time.now.iso8601,
          "netAmount" => "500.00",
          "grossAmount" => "615.00",
          "currency" => "USD",
          "convertedOrderId" => nil,
          "createdAt" => Time.now.iso8601
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
