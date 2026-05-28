# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      class Crypto < Brapi::Resource
        # GET /api/v2/crypto
        def retrieve(**params)
          raw = get("/api/v2/crypto", params: params)
          Brapi::Models::V2::CryptoRetrieveResponse.from_h(raw)
        end

        # GET /api/v2/crypto/available
        def list_available(**params)
          raw = get("/api/v2/crypto/available", params: params)
          Brapi::Models::V2::CryptoListAvailableResponse.from_h(raw)
        end
      end
    end
  end
end
