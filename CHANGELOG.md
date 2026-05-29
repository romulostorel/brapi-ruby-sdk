# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-05-28

### Added

- **Auto-pagination** on every paginated resource. Three new public methods
  show up on `client.quote`, `client.v2.fii` and `client.v2.treasury`:
  - `#each_page { |page| ... }` — yields one full page response per iteration
    until the upstream signals `has_next_page = false` (or after `max_pages:`
    iterations, whichever comes first).
  - `#each { |item| ... }` — auto-flattens across pages, yielding each row
    (FII, bond or QuoteListItem) individually.
  - Without a block, both return an `Enumerator` so the full Ruby
    Enumerable surface is available: `client.v2.fii.first(10)`,
    `client.v2.fii.select { |f| f.dividend_yield12m > 0.1 }`,
    `client.v2.treasury.lazy.find { |b| b.indexer == "ipca" }`, etc.
- `Brapi::Resources::Paginated` mixin (declarative `paginates items: :fiis`
  in the resource class) ready to be reused by any future paginated
  endpoint.
- `max_pages:` keyword on `#each` / `#each_page` (default `10_000`)
  protects against runaway loops if a buggy upstream forgets to flip
  `has_next_page = false`.
- Resources are now `Enumerable`, so the standard `map` / `select` /
  `take` / `find` / `lazy` / `count` methods Just Work on paginated
  endpoints.

## [0.3.0] - 2026-05-28

### Added

- **FIIs (Fundos Imobiliários)** — new `client.v2.fii.*` resource backed by
  `/api/v2/fii/...`:
  - `client.v2.fii.list(**params)` — paginated listing
  - `client.v2.fii.indicators(symbols, **params)` — current NAV / yield / etc.
  - `client.v2.fii.historical(symbols, **params)` — OHLCV history
  - `client.v2.fii.dividends(symbols, **params)` — payment history
- **Macro (séries temporais)** — new `client.v2.macro.*` resource backed by
  `/api/v2/macro`:
  - `client.v2.macro.retrieve(symbols, **params)` — series + observations
    for SELIC, IPCA, CDI and other indicators
  - `client.v2.macro.list_available` — all available series + categories
- **Tesouro Direto** — new `client.v2.treasury.*` resource backed by
  `/api/v2/treasury/...`:
  - `client.v2.treasury.list(**params)` — paginated bond listing
  - `client.v2.treasury.indicators(symbols, **params)` — current rates +
    prices for specific bonds
- Typed models for every new shape: `Fii`, `FiiDividend`, `FiiHistory`,
  `MacroSeries`, `MacroObservation`, `MacroResult`, `TreasuryBond`,
  `TreasuryRateInfo`, `Pagination`, plus per-endpoint Response classes.
- `Brapi::Models::V2::Pagination` reused across the paginated FII and
  Treasury list endpoints.

### Notes

- All v0.3 endpoints require a paid brapi token (Startup or Pro plan).
- Schemas were captured directly from the live API (MXRF11, SELIC,
  tesouro-selic-01032031); an ad-hoc smoke test against brapi.dev
  confirmed round-trip parsing for every new endpoint.

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
