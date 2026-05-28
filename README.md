# brapi-ruby-sdk

[![CI](https://github.com/romulostorel/brapi-ruby-sdk/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/romulostorel/brapi-ruby-sdk/actions/workflows/ci.yml)
[![Gem Version](https://img.shields.io/gem/v/brapi-ruby-sdk.svg)](https://rubygems.org/gems/brapi-ruby-sdk)
[![Downloads](https://img.shields.io/gem/dt/brapi-ruby-sdk.svg)](https://rubygems.org/gems/brapi-ruby-sdk)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.1-red.svg)](https://www.ruby-lang.org/)

Ruby SDK for the [brapi.dev](https://brapi.dev) API — Brazilian stock market quotes, cryptocurrencies, currency exchange rates, inflation (IPCA) and prime rate (SELIC) data.

This SDK provides parity with the official [brapi TypeScript](https://github.com/brapi-dev/brapi-typescript) and [brapi Python](https://github.com/brapi-dev/brapi-python) SDKs, covering 11 endpoints in v0.1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "brapi-ruby-sdk"
```

And then execute:

```bash
bundle install
```

Or install it yourself:

```bash
gem install brapi-ruby-sdk
```

The gem package is `brapi-ruby-sdk` but you still `require "brapi"` and call `Brapi.*` in code.

Requires Ruby >= 3.1.

## Quickstart

Get a free token from [brapi.dev/dashboard](https://brapi.dev/dashboard) (four assets — `PETR4`, `MGLU3`, `VALE3`, `ITUB4` — work without authentication for testing).

```ruby
require "brapi"

Brapi.configure do |c|
  c.token = ENV.fetch("BRAPI_TOKEN")
end

response = Brapi.quote.retrieve("PETR4")
puts response.results.first.regular_market_price # => 36.65
puts response.results.first.symbol               # => "PETR4"
```

## Configuration

### Global

```ruby
Brapi.configure do |c|
  c.token        = ENV.fetch("BRAPI_TOKEN")
  c.base_url     = "https://brapi.dev"     # default
  c.timeout      = 30                      # seconds
  c.open_timeout = 10                      # seconds
  c.user_agent   = "my-app/1.0"            # default: "brapi-ruby-sdk/<VERSION>"
  c.adapter      = nil                     # Faraday adapter (e.g. :net_http, :test)
end

# Call via singleton:
Brapi.quote.retrieve("PETR4")
Brapi.v2.crypto.retrieve(coin: "BTC")
```

### Per-instance

For multi-tenant apps or testing, create a `Brapi::Client` directly:

```ruby
client = Brapi::Client.new(token: "my-token", timeout: 5)
client.quote.retrieve("PETR4")
```

## Available methods

| Method                                 | HTTP                                  | Description                            |
| -------------------------------------- | ------------------------------------- | -------------------------------------- |
| `client.quote.retrieve(tickers, ...)`  | `GET /api/quote/{tickers}`            | Stock quote (single or comma-separated)|
| `client.quote.list(...)`               | `GET /api/quote/list`                 | List/filter all available stocks       |
| `client.available.list(...)`           | `GET /api/available`                  | List of available tickers/indexes      |
| `client.v2.crypto.retrieve(...)`       | `GET /api/v2/crypto`                  | Cryptocurrency quotes                  |
| `client.v2.crypto.list_available(...)` | `GET /api/v2/crypto/available`        | Available cryptocurrencies             |
| `client.v2.currency.retrieve(...)`     | `GET /api/v2/currency`                | Currency exchange quotes (USD-BRL etc) |
| `client.v2.currency.list_available(...)`| `GET /api/v2/currency/available`     | Available currency pairs               |
| `client.v2.inflation.retrieve(...)`    | `GET /api/v2/inflation`               | Inflation/IPCA series                  |
| `client.v2.inflation.list_available`   | `GET /api/v2/inflation/available`     | Countries with inflation data          |
| `client.v2.prime_rate.retrieve(...)`   | `GET /api/v2/prime-rate`              | SELIC / prime-rate series              |
| `client.v2.prime_rate.list_available`  | `GET /api/v2/prime-rate/available`    | Countries with prime-rate data         |

All params are passed as Ruby kwargs (snake_case) and the SDK converts them to the camelCase expected by the API (e.g. `sort_by: "volume"` → `?sortBy=volume`).

## Examples

### Stock quote with modules

```ruby
resp = Brapi.quote.retrieve(
  "PETR4",
  range: "1mo",
  interval: "1d",
  modules: "summaryProfile,financialData",
  dividends: true
)

quote = resp.results.first
quote.symbol                       # => "PETR4"
quote.regular_market_price         # => 36.65
quote.regular_market_change_percent # => -0.95
quote.market_cap                   # => 483937892568
quote.fifty_two_week_range         # => "28.86 - 38.66"
quote.financial_data               # => Brapi::Models::FinancialDataEntry
quote.summary_profile              # => Brapi::Models::SummaryProfile
quote.summary_profile.industry     # => "Petróleo e Gás Integrado"
quote.default_key_statistics       # => Brapi::Models::KeyStatisticsEntry
quote.income_statement_history     # => [Brapi::Models::IncomeStatementEntry]
quote.cashflow_history             # => [Brapi::Models::CashflowEntry]
quote.value_added_history          # => [Brapi::Models::ValueAddedEntry]
quote.historical_data_price        # => [Brapi::Models::HistoricalDataPrice]
quote.dividends_data               # => Brapi::Models::DividendsData (cash + stock + subscriptions)
quote.historical_data_price        # => Array of price points (when range/interval are given)
```

### Multi-ticker

```ruby
resp = Brapi.quote.retrieve(%w[PETR4 VALE3 MGLU3 ITUB4])
resp.results.each { |q| puts "#{q.symbol}: R$ #{q.regular_market_price}" }
```

### Cryptocurrencies

```ruby
resp = Brapi.v2.crypto.retrieve(coin: "BTC,ETH", currency: "BRL")
resp.coins.each { |c| puts "#{c.coin}: R$ #{c.regular_market_price}" }
```

### Currency exchange

```ruby
resp = Brapi.v2.currency.retrieve(currency: "USD-BRL,EUR-BRL,GBP-BRL")
resp.currency.each { |c| puts "#{c.from_currency}-#{c.to_currency}: #{c.bid_price}" }
```

### Inflation (IPCA)

```ruby
resp = Brapi.v2.inflation.retrieve(country: "brazil", historical: true)
resp.inflation.each { |i| puts "#{i.date}: #{i.value}%" }
```

### Prime rate (SELIC)

```ruby
resp = Brapi.v2.prime_rate.retrieve(country: "brazil")
resp.prime_rate.each { |p| puts "#{p.date}: #{p.value}% p.a." }
```

### List/filter stocks

```ruby
resp = Brapi.quote.list(sort_by: "volume", sort_order: "desc", limit: 10, sector: "Energy")
resp.stocks.each { |s| puts "#{s.stock} (#{s.name}): R$ #{s.close}" }
puts "Page #{resp.current_page}/#{resp.total_pages}"
```

## Error handling

All errors inherit from `Brapi::Error`:

```ruby
begin
  Brapi.quote.retrieve("UNKNOWN")
rescue Brapi::AuthenticationError => e
  warn "Bad or missing token: #{e.message}"
rescue Brapi::RateLimitError => e
  warn "Rate limited; retry after #{e.retry_after}s"
rescue Brapi::NotFoundError
  warn "Ticker not found"
rescue Brapi::ServerError => e
  warn "brapi.dev outage (HTTP #{e.status})"
rescue Brapi::Error => e
  warn "Other API error: #{e.message}"
end
```

| Exception                       | Status     |
| ------------------------------- | ---------- |
| `Brapi::BadRequestError`        | 400        |
| `Brapi::AuthenticationError`    | 401        |
| `Brapi::PaymentRequiredError`   | 402        |
| `Brapi::PermissionDeniedError`  | 403        |
| `Brapi::NotFoundError`          | 404        |
| `Brapi::RateLimitError`         | 429        |
| `Brapi::ServerError`            | 5xx        |
| `Brapi::ConnectionError`        | Network    |
| `Brapi::Error`                  | base class |

Each error exposes `#status`, `#response_body`, and `#raw_response`. `RateLimitError` also has `#retry_after`.

The SDK automatically retries transient 5xx errors (502/503/504) up to twice with exponential backoff.

## Roadmap

v0.1 ships the 11 endpoints supported by the official SDKs. Future minor versions will add:

- `client.fii.*` — Real Estate Investment Funds (FIIs)
- `client.macro.*` — Macroeconomic time series
- `client.options.*` — Options chain & history
- `client.treasury.*` — Tesouro Direto
- `client.futures.*` — Futures contracts

## Development

```bash
bin/setup            # bundle install
bundle exec rspec    # tests
bundle exec rubocop  # lint
bin/console          # IRB with brapi loaded
```

## License

Apache-2.0. See [LICENSE](LICENSE).

## Disclaimer

This is an **unofficial** community SDK. For official SDKs, see [brapi-dev on GitHub](https://github.com/brapi-dev).
