# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class TreasuryRateInfo < Brapi::Model
        attribute :rate_type, type: :string
        attribute :rate_unit, type: :string
        attribute :description, type: :string
      end
    end
  end
end
