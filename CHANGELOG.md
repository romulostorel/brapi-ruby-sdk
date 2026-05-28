# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-05-28

### Added

- Initial release with parity to official brapi TypeScript/Python SDKs (11 endpoints).
- `Brapi::Client` with Faraday-based HTTP, configurable timeout, base URL, adapter and user-agent.
- Global configuration via `Brapi.configure` block.
- Per-instance configuration via `Brapi::Client.new(token: ...)`.
- Resources:
  - `client.quote.retrieve(tickers, **params)` — `GET /api/quote/{tickers}`
  - `client.quote.list(**params)` — `GET /api/quote/list`
  - `client.available.list(**params)` — `GET /api/available`
  - `client.v2.crypto.retrieve(**params)` / `list_available(**params)`
  - `client.v2.currency.retrieve(**params)` / `list_available(**params)`
  - `client.v2.inflation.retrieve(**params)` / `list_available`
  - `client.v2.prime_rate.retrieve(**params)` / `list_available`
- Typed response models (`Brapi::Models::*`) with `attr_reader` for each field.
- Error hierarchy: `Brapi::Error`, `AuthenticationError`, `RateLimitError`, `BadRequestError`,
  `PaymentRequiredError`, `PermissionDeniedError`, `NotFoundError`, `ServerError`.
- Automatic retry on 5xx (via `faraday-retry`).
- RSpec test suite with WebMock stubs.
