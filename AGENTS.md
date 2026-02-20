# AGENTS.md — Open Mercato Ruby SDK

Context for AI agents working on this gem. Read this before making changes.

## What this gem does

Thin Ruby wrapper over the Open Mercato REST API. Every endpoint in Open Mercato
maps to a `Resource` subclass here. When Open Mercato adds or changes endpoints,
the gem must be updated accordingly.

## Adding a new resource (the only recipe you need)

When Open Mercato introduces a new module or endpoint, four files need to change.
Nothing else.

### 1. Resource class — `lib/open_mercato/resources/{module}/{name}.rb`

Standard CRUD resource (covers ~90% of cases):

```ruby
# frozen_string_literal: true

module OpenMercato
  module Resources
    module Warehouses                        # new module → new directory
      class Location < Resource
        api_path "/api/warehouses/locations" # exact Open Mercato API path

        # Declare every field the API returns.
        # Keys are snake_case here; the client handles camelCase ↔ snake_case
        # automatically in both directions.
        attribute :id,          :string
        attribute :name,        :string
        attribute :code,        :string
        attribute :is_active,   :boolean     # API returns "isActive"
        attribute :capacity,    :integer
        attribute :created_at,  :string
        attribute :updated_at,  :string
      end
    end
  end
end
```

Available attribute types: `:string`, `:boolean`, `:integer`, `:decimal`.

**Resource with custom (non-CRUD) actions** — add `class << self` methods:

```ruby
class << self
  def transfer(id, destination_id:)
    OpenMercato.client.post("#{api_path}/#{id}/transfer", destination_id: destination_id)
  end
end
```

**Non-CRUD resource** (no list/find/create, only custom methods — like Search::Query):
do not inherit from `Resource`, just use `class << self`.

### 2. Spec — `spec/open_mercato/resources/{module}/{name}_spec.rb`

```ruby
# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenMercato::Resources::Warehouses::Location do
  let(:base_url) { "https://test.open-mercato.local" }

  it "has correct api_path" do
    expect(described_class.api_path).to eq("/api/warehouses/locations")
  end

  it "maps camelCase API response to snake_case attributes" do
    location = described_class.new("id" => "uuid", "name" => "Main", "isActive" => true)
    expect(location.id).to eq("uuid")
    expect(location.name).to eq("Main")
    expect(location.is_active).to be true
  end

  it "lists locations" do
    stub_request(:get, "#{base_url}/api/warehouses/locations")
      .to_return(
        status: 200,
        body: { items: [{ id: "1", name: "Main" }], total: 1, page: 1,
                pageSize: 25, totalPages: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
    locations = described_class.list
    expect(locations).to be_a(OpenMercato::Collection)
    expect(locations.first.name).to eq("Main")
  end
end
```

### 3. FakeResponses — `lib/open_mercato/testing/fake_responses.rb`

Add one `module_function` method inside `FakeResponses`. Keys must be **camelCase**
(matching the real API response):

```ruby
def warehouse_location(overrides = {})
  {
    "id"        => SecureRandom.uuid,
    "name"      => "Main Warehouse",
    "code"      => "WH-001",
    "isActive"  => true,
    "capacity"  => 1000,
    "createdAt" => Time.now.iso8601,
    "updatedAt" => Time.now.iso8601
  }.merge(overrides)
end
```

### 4. README.md — API Reference table

Add a row to the Resources table:

```markdown
| Warehouses | Location | `/api/warehouses/locations` |
```

---

## Conventions (never break these)

- Every file starts with `# frozen_string_literal: true`
- Double-quoted strings everywhere
- `api_path` is the exact path used by the Open Mercato API — check the API docs
- `attribute` names are snake_case; camelCase conversion is automatic (handled by `Client` + `Resource` initializer)
- Zeitwerk autoloads `lib/open_mercato/**` — no `require` needed, just match directory structure to module nesting
- Use `ActiveJob::Base` and `ActionController::Base` directly (never `ApplicationJob`/`ApplicationController`)

## Checklist when syncing with a new Open Mercato release

- [ ] Check the Open Mercato changelog / API docs for new endpoints or changed field names
- [ ] Add/update resource class for each new or changed endpoint
- [ ] Update `FakeResponses` to reflect current API response shapes
- [ ] Add or update specs
- [ ] Update the Resources table in README.md
- [ ] Run `bundle exec rspec` — all green
- [ ] Run `bundle exec rubocop` — no offenses
- [ ] Update `CHANGELOG.md` with the API version or date being synced

## Finding the right api_path

Open Mercato API paths follow the pattern `/api/{module}/{entity-plural}`. When
in doubt, check the Open Mercato TypeScript source under
`packages/core/src/modules/{module}/api/` — every route file exports `openApi`
with the path.

## Running tests and lint

```bash
bundle exec rspec                              # all tests
bundle exec rspec spec/path/to/file_spec.rb   # single file
bundle exec rubocop                           # lint
bundle exec rubocop -a                        # auto-fix safe offenses
```