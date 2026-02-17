RSpec.describe OpenMercato::Error do
  it "inherits from StandardError" do
    expect(described_class.superclass).to eq(StandardError)
  end
end

RSpec.describe OpenMercato::AuthenticationError do
  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end
end

RSpec.describe OpenMercato::ForbiddenError do
  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end
end

RSpec.describe OpenMercato::NotFoundError do
  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end
end

RSpec.describe OpenMercato::RateLimitError do
  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end
end

RSpec.describe OpenMercato::ServerError do
  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end
end

RSpec.describe OpenMercato::WebhookSignatureError do
  it "is an alias for Webhooks::SignatureError" do
    expect(described_class).to eq(OpenMercato::Webhooks::SignatureError)
  end

  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end

  it "can be raised and rescued as WebhookSignatureError" do
    expect {
      raise OpenMercato::WebhookSignatureError, "bad signature"
    }.to raise_error(OpenMercato::WebhookSignatureError, "bad signature")
  end

  it "can be rescued as Webhooks::SignatureError" do
    expect {
      raise OpenMercato::WebhookSignatureError, "bad signature"
    }.to raise_error(OpenMercato::Webhooks::SignatureError, "bad signature")
  end
end

RSpec.describe OpenMercato::ValidationError do
  it "inherits from Error" do
    expect(described_class.superclass).to eq(OpenMercato::Error)
  end

  describe "with no arguments" do
    subject(:error) { described_class.new }

    it "has default message" do
      expect(error.message).to eq("Validation failed")
    end

    it "has empty field_errors" do
      expect(error.field_errors).to eq({})
    end

    it "has nil details" do
      expect(error.details).to be_nil
    end
  end

  describe "with a custom message" do
    subject(:error) { described_class.new("Custom error") }

    it "uses the custom message" do
      expect(error.message).to eq("Custom error")
    end
  end

  describe "with field_errors" do
    subject(:error) do
      described_class.new(
        field_errors: { "name" => ["is required"], "email" => ["is invalid", "is taken"] }
      )
    end

    it "builds message from field errors" do
      expect(error.message).to include("name: is required")
      expect(error.message).to include("email: is invalid, is taken")
    end

    it "stores field_errors" do
      expect(error.field_errors).to eq(
        "name" => ["is required"],
        "email" => ["is invalid", "is taken"]
      )
    end
  end

  describe "with details" do
    subject(:error) { described_class.new("Bad input", details: "Extra info") }

    it "stores details" do
      expect(error.details).to eq("Extra info")
    end
  end

  describe ".from_response" do
    it "parses a response body with all fields" do
      body = {
        "error" => "Invalid data",
        "fieldErrors" => { "price" => ["must be positive"] },
        "details" => "Check your input"
      }

      error = described_class.from_response(body)

      expect(error.message).to eq("Invalid data")
      expect(error.field_errors).to eq("price" => ["must be positive"])
      expect(error.details).to eq("Check your input")
    end

    it "handles missing fieldErrors" do
      body = { "error" => "Something went wrong" }

      error = described_class.from_response(body)

      expect(error.message).to eq("Something went wrong")
      expect(error.field_errors).to eq({})
      expect(error.details).to be_nil
    end

    it "handles nil error message with field errors" do
      body = { "fieldErrors" => { "name" => ["required"] } }

      error = described_class.from_response(body)

      expect(error.message).to include("name: required")
    end
  end
end