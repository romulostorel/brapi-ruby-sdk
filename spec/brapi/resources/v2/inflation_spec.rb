# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::Inflation do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#retrieve" do
    it "calls GET /api/v2/inflation with country/range params" do
      stub_brapi(:get, "/api/v2/inflation",
                 query: { country: "brazil", historical: "true" },
                 response_body: {
                   "inflation" => [
                     { "date" => "01/05/2026", "value" => "0.40", "epochDate" => 1_761_465_600 },
                     { "date" => "01/04/2026", "value" => "0.38", "epochDate" => 1_758_787_200 }
                   ],
                   "requestedAt" => "2026-05-28T10:00:00Z",
                   "took" => "8ms"
                 })

      resp = client.v2.inflation.retrieve(country: "brazil", historical: true)

      expect(resp).to be_a(Brapi::Models::V2::InflationRetrieveResponse)
      expect(resp.inflation.size).to eq(2)
      expect(resp.inflation.first.value).to eq("0.40")
      expect(resp.inflation.first.epoch_date).to eq(1_761_465_600)
    end
  end

  describe "#list_available" do
    it "calls GET /api/v2/inflation/available" do
      stub_brapi(:get, "/api/v2/inflation/available",
                 response_body: { "countries" => %w[brazil united-states] })

      resp = client.v2.inflation.list_available
      expect(resp.countries).to eq(%w[brazil united-states])
    end
  end
end
