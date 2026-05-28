# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class Inflation < Brapi::Resource
        # GET /api/v2/inflation
        def retrieve(**params)
          raw = get("/api/v2/inflation", params: params)
          Brapi::Models::V2::InflationRetrieveResponse.from_h(raw)
        end

        # GET /api/v2/inflation/available
        def list_available
          raw = get("/api/v2/inflation/available")
          Brapi::Models::V2::InflationListAvailableResponse.from_h(raw)
        end
      end
    end
  end
end
