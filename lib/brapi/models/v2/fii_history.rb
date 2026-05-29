# frozen_string_literal: true

module Brapi
  module Models
    module V2
      # Wraps a single FII's historical price series. The historical_data_price
      # entries reuse Brapi::Models::HistoricalDataPrice (same OHLCV shape as
      # /api/quote/{ticker}?range=...).
      class FiiHistory < Brapi::Model
        attribute :symbol, type: :string
        attribute :historical_data_price, type: [Brapi::Models::HistoricalDataPrice]
      end
    end
  end
end
