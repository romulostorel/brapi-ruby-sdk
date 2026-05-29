# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class Treasury < Brapi::Resource
        # GET /api/v2/treasury/list
        def list(**params)
          raw = get("/api/v2/treasury/list", params: params)
          Brapi::Models::V2::TreasuryListResponse.from_h(raw)
        end

        # GET /api/v2/treasury/indicators?symbols=...
        def indicators(symbols, **params)
          raw = get("/api/v2/treasury/indicators", params: params.merge(symbols: format_symbols(symbols)))
          Brapi::Models::V2::TreasuryIndicatorsResponse.from_h(raw)
        end
      end
    end
  end
end
