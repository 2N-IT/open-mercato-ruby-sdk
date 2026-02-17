# Open Mercato Ruby SDK

Full-featured Ruby gem for integrating Rails applications with the [Open Mercato](https://github.com/open-mercato) ERP/CRM platform.

## Features

- **Resource classes** for all modules: Catalog, Customers, Sales, Search, Notifications, Workflows, Dictionaries, Auth
- **Webhook receiver** as a mountable Rails Engine with HMAC-SHA256 signature verification
- **ActiveModel** integration with typed attributes
- **Paginated collections** with Enumerable support
- **Testing helpers** for WebMock stubs and webhook simulation
- **Install generator** for quick Rails setup

## Requirements

- Ruby >= 3.1
- Rails >= 7.0

## Installation

Add to your Gemfile:

```ruby
gem "open_mercato"
```

Then run:

```bash
bundle install
rails generate open_mercato:install
```

This creates:
- `config/initializers/open_mercato.rb` - Configuration
- `app/services/open_mercato_handlers.rb` - Webhook handler stubs
- Mounts the webhook engine in `config/routes.rb`

## Configuration

```ruby
# config/initializers/open_mercato.rb
OpenMercato.configure do |config|
  config.api_url         = ENV["OPEN_MERCATO_URL"]
  config.api_key         = ENV["OPEN_MERCATO_API_KEY"]
  config.tenant_id       = ENV["OPEN_MERCATO_TENANT_ID"]
  config.organization_id = ENV["OPEN_MERCATO_ORG_ID"]
  config.webhook_secret  = ENV["OPEN_MERCATO_WEBHOOK_SECRET"]

  # Optional
  config.timeout         = 30     # Request timeout (seconds)
  config.retry_count     = 3      # Retry on 429/5xx
  config.async_webhooks  = true   # Process webhooks via ActiveJob
  config.logger          = Rails.logger
end
```

## Usage

### Catalog

```ruby
# List products
products = OpenMercato::Resources::Catalog::Product.list(page: 1, page_size: 25)
products.each { |p| puts p.title }
products.total_pages  # => 5
products.next_page?   # => true

# Find a product
product = OpenMercato::Resources::Catalog::Product.find("uuid")

# Create a product
result = OpenMercato::Resources::Catalog::Product.create(
  title: "New Product",
  sku: "SKU-001",
  primary_currency_code: "USD"
)
# => { "id" => "new-uuid" }

# Update a product
OpenMercato::Resources::Catalog::Product.update("uuid", title: "Updated")

# Delete a product
OpenMercato::Resources::Catalog::Product.destroy("uuid")

# Other catalog resources
OpenMercato::Resources::Catalog::Variant.list
OpenMercato::Resources::Catalog::Price.list
OpenMercato::Resources::Catalog::Category.list
OpenMercato::Resources::Catalog::Offer.list
OpenMercato::Resources::Catalog::PriceKind.list
OpenMercato::Resources::Catalog::Tag.list
```

### Customers

```ruby
people = OpenMercato::Resources::Customers::Person.list
person = OpenMercato::Resources::Customers::Person.find("uuid")

companies = OpenMercato::Resources::Customers::Company.list
deals = OpenMercato::Resources::Customers::Deal.list
activities = OpenMercato::Resources::Customers::Activity.list
```

### Sales

```ruby
orders = OpenMercato::Resources::Sales::Order.list
order = OpenMercato::Resources::Sales::Order.find("uuid")

# Quotes with special actions
OpenMercato::Resources::Sales::Quote.accept("quote-id")
OpenMercato::Resources::Sales::Quote.convert_to_order("quote-id")
OpenMercato::Resources::Sales::Quote.send_quote("quote-id")

# Other sales resources
OpenMercato::Resources::Sales::OrderLine.list
OpenMercato::Resources::Sales::Payment.list
OpenMercato::Resources::Sales::Shipment.list
OpenMercato::Resources::Sales::Channel.list
```

### Search

```ruby
results = OpenMercato::Resources::Search::Query.search("laptop", page: 1)
global_results = OpenMercato::Resources::Search::Query.global("laptop")
OpenMercato::Resources::Search::Query.reindex(entity_type: "products")
```

### Workflows

```ruby
definitions = OpenMercato::Resources::Workflows::Definition.list
instances = OpenMercato::Resources::Workflows::Instance.list

# Signal a workflow instance
OpenMercato::Resources::Workflows::Instance.signal("instance-id", "approve", comment: "Looks good")
```

### Dictionaries

```ruby
dictionaries = OpenMercato::Resources::Dictionaries::Dictionary.list
entries = OpenMercato::Resources::Dictionaries::Entry.list
```

### Filtering and Sorting

All `.list` calls accept filter and sort parameters:

```ruby
# Filter with operators
products = OpenMercato::Resources::Catalog::Product.list(
  "filter[isActive][$eq]" => true,
  "filter[title][$ilike]" => "%laptop%",
  sort: "-created_at",
  page: 1,
  page_size: 50
)
```

## Webhooks

### Handler Registration

```ruby
# app/services/open_mercato_handlers.rb

# Exact match
OpenMercato::Webhooks::Handler.on("sales.orders.created") do |event|
  order_data = event.data
  event.record_id       # => "uuid"
  event.module_name     # => "sales"
  event.entity_name     # => "orders"
  event.action_name     # => "created"
  event.created?        # => true
  event.tenant_id       # => "tenant-uuid"
end

# Wildcard match (all sales events)
OpenMercato::Webhooks::Handler.on("sales.*") do |event|
  Rails.logger.info "Sales event: #{event.type}"
end

# Catch-all
OpenMercato::Webhooks::Handler.on("*") do |event|
  Rails.logger.info "Event: #{event.type}"
end

# Class-based handler
class OrderSyncHandler
  def call(event)
    Order.sync_from_mercato(event.data)
  end
end
OpenMercato::Webhooks::Handler.on("sales.orders.created", OrderSyncHandler.new)
```

### Webhook Endpoint

The engine mounts at `/open_mercato/webhooks` (POST).

Signature format: `X-OpenMercato-Signature: t=<timestamp>,v1=<hmac-sha256>`

## Error Handling

```ruby
begin
  OpenMercato::Resources::Catalog::Product.create(title: "")
rescue OpenMercato::ValidationError => e
  e.message       # => "Validation failed: title: can't be blank"
  e.field_errors  # => { "title" => ["can't be blank"] }
  e.details       # => [{ "path" => ["title"], "message" => "can't be blank" }]
rescue OpenMercato::AuthenticationError
  # 401 - invalid API key
rescue OpenMercato::ForbiddenError
  # 403 - insufficient permissions
rescue OpenMercato::NotFoundError
  # 404 - resource not found
rescue OpenMercato::RateLimitError
  # 429 - rate limited (auto-retried by default)
rescue OpenMercato::ServerError
  # 5xx - server error
rescue OpenMercato::Error => e
  # Base error class
end
```

## Testing

### Setup

```ruby
# spec/rails_helper.rb or spec/spec_helper.rb
require "open_mercato/testing"

RSpec.configure do |config|
  config.include OpenMercato::Testing::RequestStubs
  config.include OpenMercato::Testing::WebhookHelpers

  config.before(:each) do
    OpenMercato::Testing.setup!
  end
end
```

### Stubbing API Calls

```ruby
RSpec.describe ProductSync do
  it "syncs products" do
    items = [OpenMercato::Testing::FakeResponses.product("title" => "Laptop")]
    stub_mercato_list("/api/catalog/products", items: items, "total" => 1)

    products = OpenMercato::Resources::Catalog::Product.list
    expect(products.first.title).to eq("Laptop")
  end

  it "handles creation" do
    stub_mercato_create("/api/catalog/products", response: { "id" => "new-uuid" })

    result = OpenMercato::Resources::Catalog::Product.create(title: "New")
    expect(result["id"]).to eq("new-uuid")
  end
end
```

### Simulating Webhooks

```ruby
RSpec.describe OrderHandler do
  include OpenMercato::Testing::WebhookHelpers

  it "processes order events" do
    received = nil
    OpenMercato::Webhooks::Handler.on("sales.orders.created") { |e| received = e }

    simulate_mercato_webhook("sales.orders.created", data: { "id" => "order-123" })

    expect(received.record_id).to eq("order-123")
  end

  it "generates signed requests" do
    request = signed_mercato_webhook_request("test.event", data: { "id" => "123" })
    # request[:payload] - JSON string
    # request[:headers] - Hash with X-OpenMercato-Signature and Content-Type
  end
end
```

## API Reference

### Resources

| Module | Resource | API Path |
|--------|----------|----------|
| Catalog | Product | `/api/catalog/products` |
| Catalog | Variant | `/api/catalog/variants` |
| Catalog | Price | `/api/catalog/prices` |
| Catalog | Category | `/api/catalog/categories` |
| Catalog | Offer | `/api/catalog/offers` |
| Catalog | PriceKind | `/api/catalog/price-kinds` |
| Catalog | Tag | `/api/catalog/tags` |
| Customers | Person | `/api/customers/people` |
| Customers | Company | `/api/customers/companies` |
| Customers | Deal | `/api/customers/deals` |
| Customers | Activity | `/api/customers/activities` |
| Customers | Address | `/api/customers/addresses` |
| Customers | Comment | `/api/customers/comments` |
| Customers | Tag | `/api/customers/tags` |
| Sales | Order | `/api/sales/orders` |
| Sales | OrderLine | `/api/sales/order-lines` |
| Sales | Quote | `/api/sales/quotes` |
| Sales | Payment | `/api/sales/payments` |
| Sales | Shipment | `/api/sales/shipments` |
| Sales | Channel | `/api/sales/channels` |
| Sales | ShippingMethod | `/api/sales/shipping-methods` |
| Sales | PaymentMethod | `/api/sales/payment-methods` |
| Sales | TaxRate | `/api/sales/tax-rates` |
| Search | Query | `/api/search/search` |
| Notifications | Notification | `/api/notifications` |
| Workflows | Definition | `/api/workflows/definitions` |
| Workflows | Instance | `/api/workflows/instances` |
| Dictionaries | Dictionary | `/api/dictionaries` |
| Dictionaries | Entry | `/api/dictionaries/entries` |
| Auth | User | `/api/auth/users` |
| Auth | ApiKey | `/api/api_keys/keys` |

### Standard Resource Methods

All resources (except Search::Query) support:
- `.list(params = {})` - returns `OpenMercato::Collection`
- `.find(id)` - returns Resource instance
- `.create(attributes)` - returns `{ "id" => "uuid" }`
- `.update(id, attributes)` - returns `{ "ok" => true }`
- `.destroy(id)` - returns `{ "ok" => true }`

### Special Methods

- `Quote.accept(id)`, `Quote.convert_to_order(id)`, `Quote.send_quote(id)`
- `Workflows::Instance.signal(id, signal_name, payload)`
- `Search::Query.search(q)`, `Search::Query.global(q)`, `Search::Query.reindex(params)`

## License

MIT
