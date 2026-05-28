# frozen_string_literal: true

module Brapi
  module Models
    class HistoricalDataPrice < Brapi::Model
      attribute :date, type: :integer
      attribute :open, type: :float
      attribute :high, type: :float
      attribute :low, type: :float
      attribute :close, type: :float
      attribute :volume, type: :integer
      attribute :adjusted_close, type: :float
    end
  end
end
