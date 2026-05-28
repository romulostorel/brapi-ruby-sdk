# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class Macro < Brapi::Resource
        # GET /api/v2/macro?symbols=...
        def retrieve(symbols, **params)
          raw = get("/api/v2/macro", params: params.merge(symbols: Array(symbols).join(",")))
          Brapi::Models::V2::MacroRetrieveResponse.from_h(raw)
        end

        # GET /api/v2/macro/available
        def list_available
          raw = get("/api/v2/macro/available")
          Brapi::Models::V2::MacroListAvailableResponse.from_h(raw)
        end
      end
    end
  end
end
