# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-05-28

### Added

- Typed models for every fundamental module that `client.quote.retrieve(...)`
  can return when `modules:` is passed:
  - `Brapi::Models::SummaryProfile` — company profile (industry, sector,
    website, CNPJ, business summary, employees, administrator fields).
  - `Brapi::Models::KeyStatisticsEntry` — `defaultKeyStatistics` (TTM, single
    object) and `defaultKeyStatisticsHistory*` (annual + quarterly arrays),
    including special JSON keys like `52WeekChange` / `SandP52WeekChange`.
  - `Brapi::Models::IncomeStatementEntry` — DRE entries (annual + quarterly).
  - `Brapi::Models::CashflowEntry` — DFC entries (annual + quarterly).
  - `Brapi::Models::ValueAddedEntry` — DVA entries (annual + quarterly).
- `Brapi::Models::HistoricalDataPrice` for `historical_data_price` entries
  plus the surrounding `used_interval` / `used_range` / `valid_intervals` /
  `valid_ranges` Quote-level fields returned when `range`/`interval` are set.
- `Brapi::Models::DividendsData` (returned when `dividends=true`) wrapping
  three typed sub-models: `CashDividend`, `StockDividend`, `Subscription`.

### Changed

- `Brapi::Models::Quote#summary_profile`, `#default_key_statistics`,
  `#income_statement_history` (and quarterly), `#cashflow_history` (and
  quarterly), `#value_added_history` (and quarterly) and `#dividends_data`
  now return typed `Brapi::Models::*` instances instead of raw Hashes /
  Arrays. Callers that were treating these as Hashes need to switch to
  attribute access (`quote.summary_profile.industry` instead of
  `quote.summary_profile["industry"]`); `Model#raw` still exposes the
  original payload when needed.
- `Brapi::Models::Quote#historical_data_price` (returned when `range`/
  `interval` is passed) now resolves to `[Brapi::Models::HistoricalDataPrice]`
  with typed `open`/`high`/`low`/`close`/`volume`/`adjusted_close` attributes
  instead of an Array of Hashes. Code building charts off this attribute
  needs to switch from `entry["close"]` to `entry.close`.
- `Brapi::Models::BalanceSheetEntry` — fixed JSON-key mismatches for
  `goodwill` (was looking up `goodwill`, API returns `goodWill`),
  `other_current_liabilities` (`otherCurrentLiab`), `other_liabilities`
  (`otherLiab`) and `total_liabilities` (`totalLiab`); added `type`,
  `minority_interest`, `capital_surplus`. Pre-existing v0.1.0 callers that
  read these four fields will now see actual values (they returned `nil`
  before).
- `Brapi::Models::FinancialDataEntry` — adds `type`, `current_price`,
  `earnings_growth_annual` and `revenue_growth_annual` so it can model
  `financialDataHistory[*]` (annual + quarterly) in addition to the TTM
  `financialData` object.

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
