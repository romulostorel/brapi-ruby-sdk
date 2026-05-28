# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class Crypto < Brapi::Model
        attribute :currency, type: :string
        attribute :currency_rate_from_usd, type: :float
        attribute :coin_name, type: :string
        attribute :coin, type: :string
        attribute :regular_market_change, type: :float
        attribute :regular_market_change_percent, type: :float
        attribute :regular_market_time, type: :time
        attribute :regular_market_price, type: :float
        attribute :regular_market_day_low, type: :float
        attribute :regular_market_day_high, type: :float
        attribute :regular_market_day_range, type: :string
        attribute :regular_market_volume, type: :float
        attribute :market_cap, type: :float
        attribute :coin_image_url, type: :string
        attribute :historical_data_price
      end
    end
  end
end
