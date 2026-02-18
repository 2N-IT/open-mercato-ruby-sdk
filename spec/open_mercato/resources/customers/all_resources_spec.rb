# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Customers resources" do
  {
    OpenMercato::Resources::Customers::Person => "/api/customers/people",
    OpenMercato::Resources::Customers::Company => "/api/customers/companies",
    OpenMercato::Resources::Customers::Deal => "/api/customers/deals",
    OpenMercato::Resources::Customers::Activity => "/api/customers/activities",
    OpenMercato::Resources::Customers::Address => "/api/customers/addresses",
    OpenMercato::Resources::Customers::Comment => "/api/customers/comments",
    OpenMercato::Resources::Customers::Tag => "/api/customers/tags"
  }.each do |klass, expected_path|
    describe klass.name do
      it "has api_path #{expected_path}" do
        expect(klass.api_path).to eq(expected_path)
      end

      it "inherits from Resource" do
        expect(klass.superclass).to eq(OpenMercato::Resource)
      end

      it "defines id attribute" do
        instance = klass.new("id" => "test-id")
        expect(instance.id).to eq("test-id")
      end
    end
  end
end
