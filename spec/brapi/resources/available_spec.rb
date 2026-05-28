# frozen_string_literal: true

RSpec.describe Brapi::Resources::Available do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#list" do
    it "calls GET /api/available and parses the response" do
      stub_brapi(:get, "/api/available",
                 response_body: { "indexes" => %w[^BVSP ^IBX], "stocks" => %w[PETR4 VALE3 MGLU3] })

      resp = client.available.list

      expect(resp).to be_a(Brapi::Models::AvailableListResponse)
      expect(resp.stocks).to eq(%w[PETR4 VALE3 MGLU3])
      expect(resp.indexes).to eq(%w[^BVSP ^IBX])
    end

    it "accepts a search query param" do
      stub_brapi(:get, "/api/available", query: { search: "PETR" }, response_body: { stocks: [] })
      client.available.list(search: "PETR")

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/available")
        .with(query: { search: "PETR" })
    end
  end
end
