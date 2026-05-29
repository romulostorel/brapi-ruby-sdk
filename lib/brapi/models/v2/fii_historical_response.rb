# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class FiiHistoricalResponse < Brapi::Model
        attribute :fiis, type: [Brapi::Models::V2::FiiHistory]
        attribute :requested_at, type: :time
        attribute :took, type: :integer
      end
    end
  end
end
