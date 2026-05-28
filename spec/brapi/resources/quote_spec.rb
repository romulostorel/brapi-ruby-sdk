# frozen_string_literal: true

RSpec.describe Brapi::Resources::Quote do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#retrieve" do
    let(:body) do
      {
        "results" => [{
          "symbol" => "PETR4",
          "shortName" => "PETR4",
          "longName" => "Petroleo Brasileiro SA Pfd",
          "currency" => "BRL",
          "regularMarketPrice" => 36.65,
          "regularMarketChange" => -0.35,
          "regularMarketChangePercent" => -0.95,
          "regularMarketTime" => "2026-02-08T16:24:54.000Z",
          "marketCap" => 483_937_892_568,
          "regularMarketVolume" => 27_681_100,
          "fiftyTwoWeekRange" => "28.86 - 38.66",
          "logourl" => "https://icons.brapi.dev/icons/PETR4.svg"
        }],
        "requestedAt" => "2026-02-08T16:25:28.170Z",
        "took" => 3
      }
    end

    it "calls GET /api/quote/{tickers} and parses the response" do
      stub_brapi(:get, "/api/quote/PETR4", response_body: body)

      resp = client.quote.retrieve("PETR4")

      expect(resp).to be_a(Brapi::Models::QuoteRetrieveResponse)
      expect(resp.results.first.symbol).to eq("PETR4")
      expect(resp.results.first.regular_market_price).to eq(36.65)
      expect(resp.results.first.market_cap).to eq(483_937_892_568)
      expect(resp.requested_at).to be_a(Time)
      expect(resp.took).to eq(3)
    end

    it "joins arrays of tickers with comma" do
      stub_brapi(:get, "/api/quote/PETR4,VALE3", response_body: body)
      client.quote.retrieve(%w[PETR4 VALE3])

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/quote/PETR4,VALE3")
    end

    it "passes range/interval/modules query params (camelized)" do
      stub_brapi(:get, "/api/quote/PETR4",
                 query: { range: "1mo", interval: "1d", modules: "summaryProfile" },
                 response_body: body)

      client.quote.retrieve("PETR4", range: "1mo", interval: "1d", modules: "summaryProfile")

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/quote/PETR4")
        .with(query: hash_including(range: "1mo", interval: "1d", modules: "summaryProfile"))
    end

    it "raises AuthenticationError on 401" do
      stub_brapi(:get, "/api/quote/PETR4", status: 401, response_body: { message: "Invalid token" })

      expect { client.quote.retrieve("PETR4") }.to raise_error(Brapi::AuthenticationError, /Invalid token/)
    end
  end

  describe "#list" do
    it "calls GET /api/quote/list and parses the response" do
      stub_brapi(:get, "/api/quote/list",
                 query: { limit: "5", page: "1" },
                 response_body: { "stocks" => [{ "stock" => "PETR4", "close" => 36.5 }],
                                  "currentPage" => 1, "totalPages" => 10, "hasNextPage" => true })

      resp = client.quote.list(limit: 5, page: 1)

      expect(resp).to be_a(Brapi::Models::QuoteListResponse)
      expect(resp.stocks.first.stock).to eq("PETR4")
      expect(resp.stocks.first.close).to eq(36.5)
      expect(resp.current_page).to eq(1)
      expect(resp.total_pages).to eq(10)
      expect(resp.has_next_page).to be(true)
    end
  end
end
