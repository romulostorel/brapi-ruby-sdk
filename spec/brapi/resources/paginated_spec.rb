# frozen_string_literal: true

RSpec.describe Brapi::Resources::Paginated do
  let(:client) { Brapi::Client.new(token: "tok") }

  describe "#each_page (nested pagination shape)" do
    before do
      stub_brapi(:get, "/api/v2/fii/list", query: { page: "1" },
                                           response_body: {
                                             "fiis" => [{ "symbol" => "AAA11" }],
                                             "pagination" => { "page" => 1, "totalPages" => 3,
                                                               "hasNextPage" => true }
                                           })
      stub_brapi(:get, "/api/v2/fii/list", query: { page: "2" },
                                           response_body: {
                                             "fiis" => [{ "symbol" => "BBB11" }],
                                             "pagination" => { "page" => 2, "totalPages" => 3,
                                                               "hasNextPage" => true }
                                           })
      stub_brapi(:get, "/api/v2/fii/list", query: { page: "3" },
                                           response_body: {
                                             "fiis" => [{ "symbol" => "CCC11" }],
                                             "pagination" => { "page" => 3, "totalPages" => 3,
                                                               "hasNextPage" => false }
                                           })
    end

    it "walks pages until pagination.has_next_page is false" do
      symbols_per_page = []
      client.v2.fii.each_page do |page|
        symbols_per_page << page.fiis.map(&:symbol)
      end
      expect(symbols_per_page).to eq([%w[AAA11], %w[BBB11], %w[CCC11]])
    end

    it "returns an Enumerator when no block given" do
      enum = client.v2.fii.each_page
      expect(enum).to be_an(Enumerator)
      pages = enum.to_a
      expect(pages.size).to eq(3)
      expect(pages.last.fiis.first.symbol).to eq("CCC11")
    end

    it "honors a max_pages cap" do
      seen = []
      client.v2.fii.each_page(max_pages: 2) { |p| seen << p.pagination.page }
      expect(seen).to eq([1, 2])
    end
  end

  describe "#each (auto-flatten across pages)" do
    before do
      stub_brapi(:get, "/api/v2/fii/list", query: { page: "1" },
                                           response_body: {
                                             "fiis" => [{ "symbol" => "AAA11" }, { "symbol" => "BBB11" }],
                                             "pagination" => { "page" => 1, "hasNextPage" => true }
                                           })
      stub_brapi(:get, "/api/v2/fii/list", query: { page: "2" },
                                           response_body: {
                                             "fiis" => [{ "symbol" => "CCC11" }],
                                             "pagination" => { "page" => 2, "hasNextPage" => false }
                                           })
    end

    it "yields every item across all pages" do
      symbols = client.v2.fii.map(&:symbol)
      expect(symbols).to eq(%w[AAA11 BBB11 CCC11])
    end

    it "supports Enumerable methods via Enumerator" do
      expect(client.v2.fii.each.map(&:symbol).first(2)).to eq(%w[AAA11 BBB11])
    end
  end

  describe "flat-pagination shape (Quote)" do
    it "uses has_next_page / current_page on the response root" do
      stub_brapi(:get, "/api/quote/list", query: { page: "1" },
                                          response_body: {
                                            "stocks" => [{ "stock" => "PETR4" }],
                                            "currentPage" => 1, "totalPages" => 2,
                                            "hasNextPage" => true
                                          })
      stub_brapi(:get, "/api/quote/list", query: { page: "2" },
                                          response_body: {
                                            "stocks" => [{ "stock" => "VALE3" }],
                                            "currentPage" => 2, "totalPages" => 2,
                                            "hasNextPage" => false
                                          })

      symbols = client.quote.map(&:stock)
      expect(symbols).to eq(%w[PETR4 VALE3])
    end
  end

  describe "stops gracefully when pagination metadata is missing" do
    it "treats missing pagination as a single-page response" do
      stub_brapi(:get, "/api/v2/treasury/list", query: { page: "1" },
                                                response_body: {
                                                  "results" => [{ "symbol" => "tesouro-selic" }]
                                                })

      pages = client.v2.treasury.each_page.to_a
      expect(pages.size).to eq(1)
      expect(pages.first.results.first.symbol).to eq("tesouro-selic")
    end
  end

  describe "respects a caller-supplied starting page" do
    it "begins walking from the given page" do
      stub_brapi(:get, "/api/v2/fii/list", query: { page: "5" },
                                           response_body: {
                                             "fiis" => [{ "symbol" => "FROM-5" }],
                                             "pagination" => { "page" => 5, "hasNextPage" => false }
                                           })

      symbols = client.v2.fii.each(page: 5).map(&:symbol)
      expect(symbols).to eq(%w[FROM-5])
    end
  end
end
