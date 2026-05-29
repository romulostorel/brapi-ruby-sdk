# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class MacroObservation < Brapi::Model
        attribute :date, type: :date
        attribute :value, type: :float
      end
    end
  end
end
