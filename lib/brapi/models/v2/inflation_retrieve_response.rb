# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class InflationRetrieveResponse < Brapi::Model
        attribute :inflation, type: [Brapi::Models::V2::InflationEntry]
        attribute :requested_at, type: :time
        attribute :took, type: :string
      end
    end
  end
end
