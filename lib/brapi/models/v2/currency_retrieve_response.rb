# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class CurrencyRetrieveResponse < Brapi::Model
        attribute :currency, type: [Brapi::Models::V2::Currency]
        attribute :requested_at, type: :time
        attribute :took, type: :string
      end
    end
  end
end
