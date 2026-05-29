# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::Fii do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#list" do
    it "calls GET /api/v2/fii/list and parses pagination + FIIs" do
      stub_brapi(:get, "/api/v2/fii/list",
                 query: { limit: "2" },
                 response_body: {
                   "fiis" => [
                     { "symbol" => "MXRF11", "name" => "FII MAXI RENDA RL",
                       "cnpj" => "97521225000125", "segmentoAtuacao" => "Logística",
                       "tipoGestao" => "Ativa", "price" => 9.91, "navPerShare" => 9.37,
                       "priceToNav" => 1.057, "dividendYield12m" => 0.1205,
                       "totalInvestors" => 1_453_148, "segmentType" => "papel" }
                   ],
                   "pagination" => { "page" => 1, "limit" => 2, "totalItems" => 1610,
                                     "totalPages" => 805, "hasNextPage" => true },
                   "requestedAt" => "2026-05-28T18:00:00Z",
                   "took" => 12
                 })

      resp = client.v2.fii.list(limit: 2)

      expect(resp).to be_a(Brapi::Models::V2::FiiListResponse)
      expect(resp.fiis.first).to be_a(Brapi::Models::V2::Fii)
      expect(resp.fiis.first.symbol).to eq("MXRF11")
      expect(resp.fiis.first.dividend_yield12m).to eq(0.1205)
      expect(resp.fiis.first.segmento_atuacao).to eq("Logística")
      expect(resp.pagination.total_items).to eq(1610)
      expect(resp.pagination.has_next_page).to be(true)
    end
  end

  describe "#indicators" do
    it "calls GET /api/v2/fii/indicators with symbols and parses indicator-only fields" do
      stub_brapi(:get, "/api/v2/fii/indicators",
                 query: { symbols: "MXRF11,KNRI11" },
                 response_body: {
                   "fiis" => [
                     { "symbol" => "MXRF11", "asOfDate" => "2026-04-01",
                       "price" => 9.91, "navPerShare" => 9.37,
                       "dividendYield12m" => 0.1205, "dividendYield1m" => 0.01009,
                       "monthlyReturn" => 0.011, "totalInvestors" => 1_453_148,
                       "sharesOutstanding" => 460_269_540,
                       "equity" => 4_316_748_300, "totalAssets" => 4_431_403_000,
                       "segmentType" => "papel" }
                   ]
                 })

      resp = client.v2.fii.indicators(%w[MXRF11 KNRI11])

      expect(resp).to be_a(Brapi::Models::V2::FiiIndicatorsResponse)
      first = resp.fiis.first
      expect(first.dividend_yield1m).to eq(0.01009)
      expect(first.monthly_return).to eq(0.011)
      expect(first.shares_outstanding).to eq(460_269_540)
      expect(first.as_of_date).to eq(Date.new(2026, 4, 1))
    end

    it "returns nil as_of_date when used to back the list endpoint shape" do
      list_fii = Brapi::Models::V2::Fii.from_h(
        "symbol" => "MXRF11", "name" => "FII MAXI RENDA RL",
        "price" => 9.91, "dividendYield12m" => 0.1205
      )
      expect(list_fii.symbol).to eq("MXRF11")
      expect(list_fii.as_of_date).to be_nil
      expect(list_fii.dividend_yield1m).to be_nil
    end
  end

  describe "#historical" do
    it "calls GET /api/v2/fii/historical and wraps OHLCV in HistoricalDataPrice" do
      stub_brapi(:get, "/api/v2/fii/historical",
                 query: { symbols: "MXRF11" },
                 response_body: {
                   "fiis" => [
                     { "symbol" => "MXRF11",
                       "historicalDataPrice" => [
                         { "date" => 1_779_850_800, "open" => 9.97, "high" => 9.98,
                           "low" => 9.89, "close" => 9.91, "volume" => 1_802_771,
                           "adjustedClose" => 9.91 }
                       ] }
                   ]
                 })

      resp = client.v2.fii.historical("MXRF11")
      entry = resp.fiis.first
      expect(entry).to be_a(Brapi::Models::V2::FiiHistory)
      expect(entry.historical_data_price.first).to be_a(Brapi::Models::HistoricalDataPrice)
      expect(entry.historical_data_price.first.close).to eq(9.91)
    end
  end

  describe "#dividends" do
    it "calls GET /api/v2/fii/dividends and parses with Time coercion" do
      stub_brapi(:get, "/api/v2/fii/dividends",
                 query: { symbols: "MXRF11" },
                 response_body: {
                   "dividends" => [
                     { "symbol" => "MXRF11", "label" => "RENDIMENTO",
                       "rate" => 0.1, "paymentDate" => "2026-05-15 00:00:00+00",
                       "lastDatePrior" => "2026-04-30 00:00:00+00",
                       "remarks" => "fii-dividends-csv" }
                   ]
                 })

      resp = client.v2.fii.dividends("MXRF11")
      div = resp.dividends.first
      expect(div).to be_a(Brapi::Models::V2::FiiDividend)
      expect(div.rate).to eq(0.1)
      expect(div.payment_date).to be_a(Time)
    end
  end
end
