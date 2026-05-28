# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::PrimeRate do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#retrieve" do
    it "calls GET /api/v2/prime-rate with country param" do
      stub_brapi(:get, "/api/v2/prime-rate",
                 query: { country: "brazil" },
                 response_body: {
                   "primeRate" => [
                     { "date" => "01/05/2026", "value" => "10.75", "epochDate" => 1_761_465_600 }
                   ],
                   "requestedAt" => "2026-05-28T10:00:00Z",
                   "took" => "6ms"
                 })

      resp = client.v2.prime_rate.retrieve(country: "brazil")

      expect(resp).to be_a(Brapi::Models::V2::PrimeRateRetrieveResponse)
      expect(resp.prime_rate.first.value).to eq("10.75")
    end
  end

  describe "#list_available" do
    it "calls GET /api/v2/prime-rate/available" do
      stub_brapi(:get, "/api/v2/prime-rate/available",
                 response_body: { "countries" => %w[brazil] })

      resp = client.v2.prime_rate.list_available
      expect(resp.countries).to eq(%w[brazil])
    end
  end
end
