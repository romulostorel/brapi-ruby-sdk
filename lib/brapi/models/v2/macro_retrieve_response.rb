# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class MacroRetrieveResponse < Brapi::Model
        attribute :results, type: [Brapi::Models::V2::MacroResult]
        attribute :requested_at, type: :time
        attribute :took, type: :integer
      end
    end
  end
end
