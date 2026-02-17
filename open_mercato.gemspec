require_relative "lib/open_mercato/version"

Gem::Specification.new do |spec|
  spec.name          = "open_mercato"
  spec.version       = OpenMercato::VERSION
  spec.authors       = ["Open Mercato"]
  spec.summary       = "Ruby SDK for Open Mercato API"
  spec.description   = "Full-featured Rails SDK for integrating with Open Mercato ERP/CRM platform."
  spec.homepage      = "https://github.com/open-mercato/ruby-sdk"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*", "app/**/*", "config/**/*", "LICENSE", "README.md"]

  spec.add_dependency "faraday", ">= 2.0", "< 3.0"
  spec.add_dependency "faraday-retry", ">= 2.0"
  spec.add_dependency "railties", ">= 7.0", "< 9.0"
  spec.add_dependency "activesupport", ">= 7.0", "< 9.0"
  spec.add_dependency "activemodel", ">= 7.0", "< 9.0"
  spec.add_dependency "activejob", ">= 7.0", "< 9.0"
  spec.add_dependency "actionpack", ">= 7.0", "< 9.0"
  spec.add_dependency "zeitwerk", ">= 2.6"

  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "webmock", "~> 3.0"
end