# frozen_string_literal: true

module Brapi
  module Models
    module V2
      # One result entry from /api/v2/macro: a MacroSeries description plus
      # the observation rows (date + value) for that series.
      class MacroResult < Brapi::Model
        attribute :series, type: Brapi::Models::V2::MacroSeries
        attribute :observations, type: [Brapi::Models::V2::MacroObservation]
      end
    end
  end
end
