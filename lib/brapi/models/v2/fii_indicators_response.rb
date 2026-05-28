# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class FiiIndicatorsResponse < Brapi::Model
        attribute :fiis, type: [Brapi::Models::V2::Fii]
        attribute :requested_at, type: :time
        attribute :took, type: :integer
      end
    end
  end
end
