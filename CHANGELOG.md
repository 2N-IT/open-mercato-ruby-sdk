# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2024-01-01

### Added
- Initial release
- Full Ruby SDK for Open Mercato ERP/CRM API
- Rails Engine with webhook endpoint
- Resource classes for Catalog, Customers, Sales, Workflows, Auth, Notifications, Dictionaries, Search
- Webhook system with HMAC-SHA256 signature verification
- Rails generator for SDK installation (`rails generate open_mercato:install`)
- Testing helpers module (`OpenMercato::Testing`) with FakeResponses, RequestStubs, WebhookHelpers
