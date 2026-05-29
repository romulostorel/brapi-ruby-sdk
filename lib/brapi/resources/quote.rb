# frozen_string_literal: true

require "cgi"

module Brapi
  module Resources
    class Quote < Brapi::Resource
      include Brapi::Resources::Paginated

      paginates items: :stocks,
                has_next: lambda(&:has_next_page),
                next_page: ->(r) { (r.current_page || 0) + 1 }

      # GET /api/quote/{tickers}
      def retrieve(tickers, **params)
        tickers_str = Array(tickers).join(",")
        raw = get("/api/quote/#{CGI.escape(tickers_str)}", params: params)
        Brapi::Models::QuoteRetrieveResponse.from_h(raw)
      end

      # GET /api/quote/list
      def list(**params)
        raw = get("/api/quote/list", params: params)
        Brapi::Models::QuoteListResponse.from_h(raw)
      end
    end
  end
end
