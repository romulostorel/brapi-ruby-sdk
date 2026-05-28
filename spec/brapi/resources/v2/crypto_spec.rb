# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::Crypto do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#retrieve" do
    it "calls GET /api/v2/crypto with coin/currency params" do
      stub_brapi(:get, "/api/v2/crypto",
                 query: { coin: "BTC", currency: "BRL" },
                 response_body: {
                   "coins" => [{
                     "currency" => "BRL",
                     "coin" => "BTC",
                     "coinName" => "Bitcoin",
                     "regularMarketPrice" => 350_000.0,
                     "regularMarketChangePercent" => 1.5,
                     "marketCap" => 1_000_000_000_000.0
                   }],
                   "requestedAt" => "2026-05-28T10:00:00Z",
                   "took" => "12ms"
                 })

      resp = client.v2.crypto.retrieve(coin: "BTC", currency: "BRL")

      expect(resp).to be_a(Brapi::Models::V2::CryptoRetrieveResponse)
      expect(resp.coins.first.coin).to eq("BTC")
      expect(resp.coins.first.coin_name).to eq("Bitcoin")
      expect(resp.coins.first.regular_market_price).to eq(350_000.0)
    end
  end

  describe "#list_available" do
    it "calls GET /api/v2/crypto/available" do
      stub_brapi(:get, "/api/v2/crypto/available",
                 response_body: { "coins" => %w[BTC ETH LTC] })

      resp = client.v2.crypto.list_available
      expect(resp.coins).to eq(%w[BTC ETH LTC])
    end
  end
end
