# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class MacroListAvailableResponse < Brapi::Model
        attribute :results, type: [Brapi::Models::V2::MacroSeries]
        attribute :categories
        attribute :count, type: :integer
        attribute :requested_at, type: :time
        attribute :took, type: :integer
      end
    end
  end
end
