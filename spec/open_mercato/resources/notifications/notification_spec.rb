# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Notifications::Notification do
  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/notifications")
  end

  it "inherits from Resource" do
    expect(described_class.superclass).to eq(OpenMercato::Resource)
  end

  it "instantiates with attributes" do
    notification = described_class.new(
      "id" => "notif-1",
      "title" => "New Order",
      "isRead" => false,
      "notificationType" => "order_created"
    )
    expect(notification.id).to eq("notif-1")
    expect(notification.title).to eq("New Order")
    expect(notification.is_read).to be(false)
    expect(notification.notification_type).to eq("order_created")
  end
end
