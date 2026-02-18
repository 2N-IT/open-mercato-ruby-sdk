# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Customers::Person do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/customers/people")
  end

  it "defines expected attributes" do
    person = described_class.new(
      "id" => "uuid", "firstName" => "John", "lastName" => "Doe",
      "email" => "john@example.com", "phone" => "+1234567890",
      "companyId" => "comp-1", "isActive" => true, "title" => "Mr."
    )
    expect(person.id).to eq("uuid")
    expect(person.first_name).to eq("John")
    expect(person.last_name).to eq("Doe")
    expect(person.email).to eq("john@example.com")
    expect(person.phone).to eq("+1234567890")
    expect(person.company_id).to eq("comp-1")
    expect(person.is_active).to be true
    expect(person.title).to eq("Mr.")
  end

  it "lists people" do
    stub_request(:get, "#{base_url}/api/customers/people")
      .to_return(
        status: 200,
        body: { items: [{ id: "1", firstName: "Jane", lastName: "Doe" }], total: 1, page: 1, pageSize: 25,
                totalPages: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
    people = described_class.list
    expect(people).to be_a(OpenMercato::Collection)
    expect(people.first.first_name).to eq("Jane")
  end
end
