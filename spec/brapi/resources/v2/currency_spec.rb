# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::Currency do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#retrieve" do
    it "calls GET /api/v2/currency with currency pair" do
      stub_brapi(:get, "/api/v2/currency",
                 query: { currency: "USD-BRL,EUR-BRL" },
                 response_body: {
                   "currency" => [{
                     "fromCurrency" => "USD",
                     "toCurrency" => "BRL",
                     "name" => "Dólar Americano/Real Brasileiro",
                     "bidPrice" => "5.2097",
                     "askPrice" => "5.2127",
                     "percentageChange" => "0.88"
                   }],
                   "requestedAt" => "2026-05-28T10:00:00Z",
                   "took" => "27ms"
                 })

      resp = client.v2.currency.retrieve(currency: "USD-BRL,EUR-BRL")

      expect(resp).to be_a(Brapi::Models::V2::CurrencyRetrieveResponse)
      first = resp.currency.first
      expect(first.from_currency).to eq("USD")
      expect(first.to_currency).to eq("BRL")
      expect(first.bid_price).to eq("5.2097")
    end
  end

  describe "#list_available" do
    it "calls GET /api/v2/currency/available" do
      stub_brapi(:get, "/api/v2/currency/available",
                 response_body: { "currencies" => %w[USD EUR GBP] })

      resp = client.v2.currency.list_available
      expect(resp.currencies).to eq(%w[USD EUR GBP])
    end
  end
end
