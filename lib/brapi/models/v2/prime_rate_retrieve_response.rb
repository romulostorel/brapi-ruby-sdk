# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class PrimeRateRetrieveResponse < Brapi::Model
        attribute :prime_rate, type: [Brapi::Models::V2::PrimeRateEntry]
        attribute :requested_at, type: :time
        attribute :took, type: :string
      end
    end
  end
end
