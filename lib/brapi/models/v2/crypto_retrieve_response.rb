# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class CryptoRetrieveResponse < Brapi::Model
        attribute :coins, type: [Brapi::Models::V2::Crypto]
        attribute :requested_at, type: :time
        attribute :took, type: :string
      end
    end
  end
end
