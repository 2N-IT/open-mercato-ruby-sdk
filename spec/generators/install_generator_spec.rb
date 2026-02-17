require "spec_helper"

RSpec.describe "Install generator templates" do
  let(:templates_dir) { File.expand_path("../../lib/generators/open_mercato/install/templates", __dir__) }

  it "has initializer template" do
    path = File.join(templates_dir, "initializer.rb.tt")
    expect(File.exist?(path)).to be true
    content = File.read(path)
    expect(content).to include("OpenMercato.configure")
    expect(content).to include("config.api_url")
    expect(content).to include("config.api_key")
  end

  it "has webhook handlers template" do
    path = File.join(templates_dir, "webhook_handlers.rb.tt")
    expect(File.exist?(path)).to be true
    content = File.read(path)
    expect(content).to include("OpenMercato::Webhooks::Handler")
  end

  it "has generator class" do
    path = File.expand_path("../../lib/generators/open_mercato/install/install_generator.rb", __dir__)
    expect(File.exist?(path)).to be true
  end
end