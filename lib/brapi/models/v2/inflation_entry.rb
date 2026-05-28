# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class InflationEntry < Brapi::Model
        attribute :date, type: :string
        attribute :value, type: :string
        attribute :epoch_date, type: :integer
      end
    end
  end
end
