# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class Currency < Brapi::Model
        attribute :from_currency, type: :string
        attribute :to_currency, type: :string
        attribute :name, type: :string
        attribute :high, type: :string
        attribute :low, type: :string
        attribute :bid_variation, type: :string
        attribute :percentage_change, type: :string
        attribute :bid_price, type: :string
        attribute :ask_price, type: :string
        attribute :updated_at_timestamp, type: :string
        attribute :updated_at_date, type: :string
      end
    end
  end
end
