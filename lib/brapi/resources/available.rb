# frozen_string_literal: true

module Brapi
  module Resources
    class Available < Brapi::Resource
      # GET /api/available
      def list(**params)
        raw = get("/api/available", params: params)
        Brapi::Models::AvailableListResponse.from_h(raw)
      end
    end
  end
end
