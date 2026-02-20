# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run all tests
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/open_mercato/client_spec.rb

# Run a specific example by line number
bundle exec rspec spec/open_mercato/client_spec.rb:42

# Lint
bundle exec rubocop

# Lint with auto-fix
bundle exec rubocop -a
```

## Architecture

This is a **Rails gem** (not a standalone app) that provides a Ruby SDK for the Open Mercato ERP/CRM API. It includes a mountable Rails Engine for webhook receiving.

### Core Layer

- **`OpenMercato.configure`** / **`OpenMercato.client`** — singleton entry points in `lib/open_mercato.rb`. Configuration validates `api_url` and `api_key` on first `client` call.
- **`Client`** (`lib/open_mercato/client.rb`) — Faraday wrapper that handles HTTP, authentication headers, retries on 429/5xx, and maps HTTP status codes to typed exceptions. Automatically converts snake_case Ruby keys to camelCase for the API.
- **`Resource`** (`lib/open_mercato/resource.rb`) — base class using `ActiveModel::Attributes`. Provides `.list`, `.find`, `.create`, `.update`, `.destroy`. The initializer maps camelCase API response keys back to snake_case attributes. Each subclass declares `api_path` and typed `attribute` fields.
- **`Collection`** (`lib/open_mercato/collection.rb`) — wraps paginated list responses, includes `Enumerable`. Exposes `total`, `page`, `page_size`, `total_pages`, `next_page?`, `prev_page?`.

### Resources

All resources live under `lib/open_mercato/resources/` organized by domain module (auth, catalog, customers, dictionaries, notifications, sales, search, workflows). Each is a subclass of `Resource` with typed attributes and a declared `api_path`. Resources with non-CRUD actions (e.g. `Quote`, `Workflows::Instance`, `Search::Query`) add extra class methods that call `OpenMercato.client` directly.

### Webhook System

Incoming webhook flow: `WebhooksController#create` → `Webhooks::Signature.verify!` → build `Webhooks::Event` → either `WebhookJob.perform_later` (async, default) or `Webhooks::Handler.dispatch` (sync).

- **`Webhooks::Signature`** — HMAC-SHA256 verification. Header format: `X-OpenMercato-Signature: t=<timestamp>,v1=<hmac>`. Uses `OpenSSL.fixed_length_secure_compare` for timing-safe comparison.
- **`Webhooks::Handler`** — class-level handler registry supporting exact patterns (`"sales.orders.created"`), wildcard (`"sales.*"`), and catch-all (`"*"`). Handlers are blocks or callables.
- **`Webhooks::Event`** — parses `type` string as `module.entity.action`, exposes `record_id` (from `data["id"]`), and provides `created?`/`updated?`/`deleted?` predicates.
- **`WebhookJob`** (`app/jobs/`) — deserializes event and dispatches to handlers. Enabled when `config.async_webhooks = true`.

### Testing Helpers

`lib/open_mercato/testing.rb` (loaded via `require "open_mercato/testing"`) provides:
- **`Testing::RequestStubs`** — WebMock-based helpers: `stub_mercato_list`, `stub_mercato_find`, `stub_mercato_create`, `stub_mercato_update`, `stub_mercato_destroy`, `stub_mercato_error`.
- **`Testing::WebhookHelpers`** — `simulate_mercato_webhook` dispatches directly to handlers; `signed_mercato_webhook_request` generates a properly-signed payload+headers hash for controller specs.
- **`Testing::FakeResponses`** — factory methods for each resource type returning minimal valid attribute hashes.

### Key Conventions

- Every file must have `# frozen_string_literal: true`.
- Use double-quoted strings (`Style/StringLiterals: double_quotes`).
- Zeitwerk autoloads everything under `lib/open_mercato/`; generators are explicitly ignored.
- The gem uses `ApplicationJob`/`ApplicationController` exclusions in RuboCop — use `ActiveJob::Base` and `ActionController::Base` directly in gem code.
- `spec/spec_helper.rb` resets `OpenMercato` configuration before each test and disables real network connections via WebMock.