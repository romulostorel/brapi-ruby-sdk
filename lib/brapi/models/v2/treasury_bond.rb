# frozen_string_literal: true

module Brapi
  module Models
    module V2
      # Single Tesouro Direto bond as returned by /api/v2/treasury/list and
      # /api/v2/treasury/indicators (both endpoints share the same shape).
      #
      # buyRate / sellRate semantics depend on the bond's indexer — see
      # TreasuryRateInfo#rate_type / #description.
      class TreasuryBond < Brapi::Model
        attribute :symbol, type: :string
        attribute :bond_type, type: :string
        attribute :indexer, type: :string
        attribute :coupon_type, type: :string
        attribute :maturity_date, type: :date
        attribute :duration_days, type: :integer
        attribute :base_date, type: :date
        attribute :buy_rate, type: :float
        attribute :sell_rate, type: :float
        attribute :buy_price, type: :float
        attribute :sell_price, type: :float
        attribute :base_price, type: :float
        attribute :rate_info, type: Brapi::Models::V2::TreasuryRateInfo
      end
    end
  end
end
