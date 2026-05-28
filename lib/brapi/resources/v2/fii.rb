# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class Fii < Brapi::Resource
        # GET /api/v2/fii/list
        def list(**params)
          raw = get("/api/v2/fii/list", params: params)
          Brapi::Models::V2::FiiListResponse.from_h(raw)
        end

        # GET /api/v2/fii/indicators?symbols=...
        def indicators(symbols, **params)
          raw = get("/api/v2/fii/indicators", params: params.merge(symbols: join_symbols(symbols)))
          Brapi::Models::V2::FiiIndicatorsResponse.from_h(raw)
        end

        # GET /api/v2/fii/historical?symbols=...
        def historical(symbols, **params)
          raw = get("/api/v2/fii/historical", params: params.merge(symbols: join_symbols(symbols)))
          Brapi::Models::V2::FiiHistoricalResponse.from_h(raw)
        end

        # GET /api/v2/fii/dividends?symbols=...
        def dividends(symbols, **params)
          raw = get("/api/v2/fii/dividends", params: params.merge(symbols: join_symbols(symbols)))
          Brapi::Models::V2::FiiDividendsResponse.from_h(raw)
        end

        private

        def join_symbols(symbols)
          Array(symbols).join(",")
        end
      end
    end
  end
end
