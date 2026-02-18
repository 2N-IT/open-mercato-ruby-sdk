# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Auth::User do
  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/auth/users")
  end

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  it "instantiates with attributes" do
    user = described_class.new(
      "id" => "user-1",
      "email" => "admin@example.com",
      "firstName" => "Jan",
      "lastName" => "Kowalski",
      "role" => "admin"
    )
    expect(user.id).to eq("user-1")
    expect(user.email).to eq("admin@example.com")
    expect(user.first_name).to eq("Jan")
    expect(user.last_name).to eq("Kowalski")
    expect(user.role).to eq("admin")
  end
end
