# frozen_string_literal: true

RSpec.describe Brapi::Resources::V2::Treasury do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#list" do
    let(:list_body) do
      {
        "results" => [
          { "symbol" => "tesouro-selic-01032031",
            "bondType" => "Tesouro Selic",
            "indexer" => "selic", "couponType" => "zero",
            "maturityDate" => "2031-03-01", "durationDays" => 1740,
            "baseDate" => "2026-05-26",
            "buyRate" => 0.08, "sellRate" => 0.09,
            "buyPrice" => 19_019.74, "sellPrice" => 19_000.47,
            "basePrice" => 19_000.47,
            "rateInfo" => { "rateType" => "spreadOverSelic",
                            "rateUnit" => "% a.a.",
                            "description" => "spread em pontos percentuais ao ano" } }
        ],
        "pagination" => { "page" => 1, "limit" => 20, "totalItems" => 50,
                          "totalPages" => 3, "hasNextPage" => true },
        "requestedAt" => "2026-05-28T18:00:00Z",
        "took" => 10
      }
    end

    it "calls GET /api/v2/treasury/list and parses bonds + rate_info + pagination" do
      stub_brapi(:get, "/api/v2/treasury/list", response_body: list_body)

      resp = client.v2.treasury.list
      bond = resp.results.first
      expect(resp).to be_a(Brapi::Models::V2::TreasuryListResponse)
      expect(bond).to be_a(Brapi::Models::V2::TreasuryBond)
      expect(bond.bond_type).to eq("Tesouro Selic")
      expect(bond.buy_rate).to eq(0.08)
      expect(bond.sell_price).to eq(19_000.47)
      expect(bond.rate_info).to be_a(Brapi::Models::V2::TreasuryRateInfo)
      expect(bond.rate_info.rate_type).to eq("spreadOverSelic")
      expect(resp.pagination.total_pages).to eq(3)
    end
  end

  describe "#indicators" do
    it "calls GET /api/v2/treasury/indicators with symbols param" do
      stub_brapi(:get, "/api/v2/treasury/indicators",
                 query: { symbols: "tesouro-selic-01032031" },
                 response_body: {
                   "results" => [
                     { "symbol" => "tesouro-selic-01032031",
                       "bondType" => "Tesouro Selic", "indexer" => "selic",
                       "buyRate" => 0.08, "sellPrice" => 19_000.47,
                       "rateInfo" => { "rateType" => "spreadOverSelic",
                                       "rateUnit" => "% a.a." } }
                   ]
                 })

      resp = client.v2.treasury.indicators("tesouro-selic-01032031")
      expect(resp).to be_a(Brapi::Models::V2::TreasuryIndicatorsResponse)
      expect(resp.results.first.buy_rate).to eq(0.08)
    end
  end
end
