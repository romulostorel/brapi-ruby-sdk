# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class PrimeRate < Brapi::Resource
        # GET /api/v2/prime-rate
        def retrieve(**params)
          raw = get("/api/v2/prime-rate", params: params)
          Brapi::Models::V2::PrimeRateRetrieveResponse.from_h(raw)
        end

        # GET /api/v2/prime-rate/available
        def list_available
          raw = get("/api/v2/prime-rate/available")
          Brapi::Models::V2::PrimeRateListAvailableResponse.from_h(raw)
        end
      end
    end
  end
end
