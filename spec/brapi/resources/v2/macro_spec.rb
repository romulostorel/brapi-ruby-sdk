# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::Macro do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#retrieve" do
    it "calls GET /api/v2/macro with symbols and parses series + observations" do
      stub_brapi(:get, "/api/v2/macro",
                 query: { symbols: "SELIC" },
                 response_body: {
                   "results" => [
                     { "series" => { "slug" => "selic", "name" => "Taxa Selic",
                                     "description" => "Taxa básica de juros...",
                                     "unit" => "percentPerYear", "frequency" => "daily",
                                     "category" => "interestRate",
                                     "startDate" => "1999-03-05" },
                       "observations" => [
                         { "date" => "2026-05-28", "value" => 14.5 },
                         { "date" => "2026-05-27", "value" => 14.5 }
                       ] }
                   ],
                   "requestedAt" => "2026-05-28T18:00:00Z",
                   "took" => 8
                 })

      resp = client.v2.macro.retrieve("SELIC")
      expect(resp).to be_a(Brapi::Models::V2::MacroRetrieveResponse)
      first = resp.results.first
      expect(first.series).to be_a(Brapi::Models::V2::MacroSeries)
      expect(first.series.slug).to eq("selic")
      expect(first.series.unit).to eq("percentPerYear")
      expect(first.observations.first).to be_a(Brapi::Models::V2::MacroObservation)
      expect(first.observations.first.value).to eq(14.5)
    end

    it "joins array of symbols with comma" do
      stub_brapi(:get, "/api/v2/macro", query: { symbols: "IPCA,SELIC" },
                                        response_body: { "results" => [] })
      client.v2.macro.retrieve(%w[IPCA SELIC])

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/v2/macro")
        .with(query: { symbols: "IPCA,SELIC" })
    end
  end

  describe "#list_available" do
    it "calls GET /api/v2/macro/available and parses series + categories" do
      stub_brapi(:get, "/api/v2/macro/available",
                 response_body: {
                   "results" => [
                     { "slug" => "selic", "name" => "Taxa Selic", "unit" => "percentPerYear" },
                     { "slug" => "ipca", "name" => "IPCA", "unit" => "percent" }
                   ],
                   "categories" => %w[interestRate inflation monetary],
                   "count" => 15,
                   "requestedAt" => "2026-05-28T18:00:00Z",
                   "took" => 4
                 })

      resp = client.v2.macro.list_available
      expect(resp).to be_a(Brapi::Models::V2::MacroListAvailableResponse)
      expect(resp.count).to eq(15)
      expect(resp.categories).to eq(%w[interestRate inflation monetary])
      expect(resp.results.first.slug).to eq("selic")
    end
  end
end
