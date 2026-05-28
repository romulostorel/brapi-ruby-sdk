# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class Currency < Brapi::Resource
        # GET /api/v2/currency
        def retrieve(**params)
          raw = get("/api/v2/currency", params: params)
          Brapi::Models::V2::CurrencyRetrieveResponse.from_h(raw)
        end

        # GET /api/v2/currency/available
        def list_available(**params)
          raw = get("/api/v2/currency/available", params: params)
          Brapi::Models::V2::CurrencyListAvailableResponse.from_h(raw)
        end
      end
    end
  end
end
