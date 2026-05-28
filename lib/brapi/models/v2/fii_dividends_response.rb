# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class FiiDividendsResponse < Brapi::Model
        attribute :dividends, type: [Brapi::Models::V2::FiiDividend]
        attribute :requested_at, type: :time
        attribute :took, type: :integer
      end
    end
  end
end
