# frozen_string_literal: true

# Exercises the typed module fields on Quote with realistic JSON payloads
# captured directly from brapi.dev. Verifies that calling
# `client.quote.retrieve("PETR4", modules: ...)` returns typed objects
# (instead of raw Hashes/Arrays) for every supported module slot.
RSpec.describe Brapi::Models::Quote, "#fundamental_modules" do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "summaryProfile" do
    let(:body) do
      {
        "results" => [{
          "symbol" => "PETR4",
          "summaryProfile" => {
            "website" => "https://petrobras.com.br",
            "industry" => "Petróleo e Gás Integrado",
            "industryKey" => "petroleo-e-gas-integrado",
            "sector" => "Energia",
            "sectorKey" => "energia",
            "longBusinessSummary" => "A Petrobras é uma sociedade...",
            "fullTimeEmployees" => 41_778,
            "twitter" => "@petrobras",
            "startDate" => "1953-10-03",
            "cnpj" => "33000167000101",
            "logoUrl" => "https://icons.brapi.dev/icons/PETR4.svg"
          }
        }],
        "requestedAt" => "2026-05-28T17:27:52.259Z",
        "took" => 2
      }
    end

    it "exposes a typed SummaryProfile" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { modules: "summaryProfile" },
                 response_body: body)

      quote = client.quote.retrieve("PETR4", modules: "summaryProfile").results.first

      expect(quote.summary_profile).to be_a(Brapi::Models::SummaryProfile)
      expect(quote.summary_profile.industry).to eq("Petróleo e Gás Integrado")
      expect(quote.summary_profile.sector).to eq("Energia")
      expect(quote.summary_profile.full_time_employees).to eq(41_778)
      expect(quote.summary_profile.cnpj).to eq("33000167000101")
    end
  end

  describe "defaultKeyStatistics (TTM single object)" do
    let(:body) do
      {
        "results" => [{
          "symbol" => "PETR4",
          "defaultKeyStatistics" => {
            "enterpriseValue" => 900_000_000_000,
            "forwardPE" => 6.2,
            "profitMargins" => 0.21,
            "sharesOutstanding" => 13_044_000_000,
            "beta" => 0.85,
            "bookValue" => 28.4,
            "priceToBook" => 1.5,
            "trailingEps" => 8.35,
            "52WeekChange" => 0.18,
            "SandP52WeekChange" => 0.11,
            "lastDividendValue" => 1.13,
            "lastDividendDate" => 1_724_457_600,
            "marketCap" => 585_399_664_445,
            "trailingPE" => 5.08,
            "dividendYield" => 0.11
          }
        }],
        "requestedAt" => "2026-05-28T17:00:00Z",
        "took" => 2
      }
    end

    it "exposes a typed KeyStatisticsEntry with the 52WeekChange overrides" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { modules: "defaultKeyStatistics" },
                 response_body: body)

      stats = client.quote.retrieve("PETR4", modules: "defaultKeyStatistics")
                    .results.first.default_key_statistics

      expect(stats).to be_a(Brapi::Models::KeyStatisticsEntry)
      expect(stats.forward_pe).to eq(6.2)
      expect(stats.beta).to eq(0.85)
      expect(stats.fifty_two_week_change).to eq(0.18)
      expect(stats.sandp_fifty_two_week_change).to eq(0.11)
      expect(stats.dividend_yield).to eq(0.11)
    end
  end

  describe "incomeStatementHistory (annual array)" do
    it "exposes typed IncomeStatementEntry items" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { modules: "incomeStatementHistory" },
                 response_body: {
                   "results" => [{
                     "incomeStatementHistory" => [
                       { "type" => "yearly", "endDate" => "2025-12-31",
                         "totalRevenue" => 500_000_000_000, "grossProfit" => 200_000_000_000,
                         "ebit" => 150_000_000_000, "netIncome" => 100_000_000_000,
                         "earningsPerShare" => 8.0 }
                     ]
                   }]
                 })

      entries = client.quote.retrieve("PETR4", modules: "incomeStatementHistory")
                      .results.first.income_statement_history

      expect(entries).to all(be_a(Brapi::Models::IncomeStatementEntry))
      expect(entries.first.total_revenue).to eq(500_000_000_000)
      expect(entries.first.net_income).to eq(100_000_000_000)
      expect(entries.first.earnings_per_share).to eq(8.0)
    end
  end

  describe "cashflowHistory" do
    it "exposes typed CashflowEntry items" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { modules: "cashflowHistory" },
                 response_body: {
                   "results" => [{
                     "cashflowHistory" => [
                       { "type" => "yearly", "endDate" => "2025-12-31",
                         "operatingCashFlow" => 200_000_000_000,
                         "freeCashFlow" => 120_000_000_000,
                         "finalCashBalance" => 80_000_000_000 }
                     ]
                   }]
                 })

      entries = client.quote.retrieve("PETR4", modules: "cashflowHistory")
                      .results.first.cashflow_history

      expect(entries.first).to be_a(Brapi::Models::CashflowEntry)
      expect(entries.first.operating_cash_flow).to eq(200_000_000_000)
      expect(entries.first.free_cash_flow).to eq(120_000_000_000)
    end
  end

  describe "valueAddedHistory" do
    it "exposes typed ValueAddedEntry items" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { modules: "valueAddedHistory" },
                 response_body: {
                   "results" => [{
                     "valueAddedHistory" => [
                       { "type" => "yearly", "endDate" => "2025-12-31",
                         "revenue" => 600_000_000_000,
                         "grossAddedValue" => 300_000_000_000,
                         "federalTaxes" => 50_000_000_000 }
                     ]
                   }]
                 })

      entries = client.quote.retrieve("PETR4", modules: "valueAddedHistory")
                      .results.first.value_added_history

      expect(entries.first).to be_a(Brapi::Models::ValueAddedEntry)
      expect(entries.first.gross_added_value).to eq(300_000_000_000)
      expect(entries.first.federal_taxes).to eq(50_000_000_000)
    end
  end

  describe "historicalDataPrice (range/interval)" do
    it "exposes typed entries and surrounding Quote-level fields" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { range: "5d", interval: "1d" },
                 response_body: {
                   "results" => [{
                     "symbol" => "PETR4",
                     "usedInterval" => "1d",
                     "usedRange" => "5d",
                     "validIntervals" => %w[1d 5d 1mo],
                     "validRanges" => %w[1d 5d 1mo 1y],
                     "historicalDataPrice" => [
                       { "date" => 1_716_249_600, "open" => 41.2, "high" => 42.5, "low" => 41.0,
                         "close" => 42.1, "volume" => 35_000_000, "adjustedClose" => 42.1 },
                       { "date" => 1_716_336_000, "open" => 42.1, "high" => 43.0, "low" => 41.8,
                         "close" => 42.6, "volume" => 32_000_000, "adjustedClose" => 42.6 }
                     ]
                   }]
                 })

      quote = client.quote.retrieve("PETR4", range: "5d", interval: "1d").results.first

      expect(quote.used_interval).to eq("1d")
      expect(quote.used_range).to eq("5d")
      expect(quote.valid_intervals).to include("1d", "5d")
      expect(quote.historical_data_price).to all(be_a(Brapi::Models::HistoricalDataPrice))
      expect(quote.historical_data_price.first.close).to eq(42.1)
      expect(quote.historical_data_price.first.volume).to eq(35_000_000)
    end
  end

  describe "dividends" do
    let(:dividends_body) do
      {
        "results" => [{
          "symbol" => "PETR4",
          "dividendsData" => {
            "cashDividends" => [
              { "assetIssued" => "BRPETRACNPR6",
                "paymentDate" => "2026-06-22T03:00:00.000Z",
                "rate" => 0.01314955,
                "label" => "RENDIMENTO",
                "isinCode" => "BRPETRACNPR6",
                "lastDatePrior" => "2026-05-15T03:00:00.000Z" }
            ],
            "stockDividends" => [
              { "assetIssued" => "BRPETRACNPR6", "factor" => 2,
                "completeFactor" => "2 para 1",
                "approvedOn" => "2008-04-25T03:00:00.000Z",
                "label" => "DESDOBRAMENTO" }
            ],
            "subscriptions" => []
          }
        }]
      }
    end

    let(:dividends_data) do
      stub_brapi(:get, "/api/quote/PETR4", query: { dividends: "true" },
                                           response_body: dividends_body)
      client.quote.retrieve("PETR4", dividends: true).results.first.dividends_data
    end

    it "wraps the payload in a typed DividendsData" do
      expect(dividends_data).to be_a(Brapi::Models::DividendsData)
      expect(dividends_data.subscriptions).to eq([])
    end

    it "parses cash dividends with Time-typed payment dates" do
      cash = dividends_data.cash_dividends.first
      expect(cash).to be_a(Brapi::Models::CashDividend)
      expect(cash.rate).to eq(0.01314955)
      expect(cash.payment_date).to be_a(Time)
    end

    it "parses stock dividends including factor metadata" do
      stock = dividends_data.stock_dividends.first
      expect(stock).to be_a(Brapi::Models::StockDividend)
      expect(stock.complete_factor).to eq("2 para 1")
    end
  end

  describe "balanceSheetHistory JSON-key fixes" do
    it "reads the corrected camelCase keys (goodWill / otherCurrentLiab / otherLiab / totalLiab)" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { modules: "balanceSheetHistory" },
                 response_body: {
                   "results" => [{
                     "balanceSheetHistory" => [
                       { "type" => "yearly", "endDate" => "2025-12-31",
                         "totalAssets" => 1_000_000_000_000,
                         "totalLiab" => 600_000_000_000,
                         "otherLiab" => 50_000_000_000,
                         "otherCurrentLiab" => 30_000_000_000,
                         "goodWill" => 5_000_000_000 }
                     ]
                   }]
                 })

      entry = client.quote.retrieve("PETR4", modules: "balanceSheetHistory")
                    .results.first.balance_sheet_history.first

      expect(entry.total_liabilities).to eq(600_000_000_000)
      expect(entry.other_liabilities).to eq(50_000_000_000)
      expect(entry.other_current_liabilities).to eq(30_000_000_000)
      expect(entry.goodwill).to eq(5_000_000_000)
    end
  end
end
