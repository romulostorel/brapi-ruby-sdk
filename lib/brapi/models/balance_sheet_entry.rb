# frozen_string_literal: true

module Brapi
  module Models
    # Common fields of `balanceSheetHistory[*]` (annual) and
    # `balanceSheetHistoryQuarterly[*]`. The full brapi payload exposes ~120
    # accounting-specific fields (Brazilian GAAP + segment-specific rows);
    # the SDK ships the most-used ones typed and keeps the rest available
    # through Model#raw.
    class BalanceSheetEntry < Brapi::Model
      attribute :type, type: :string
      attribute :end_date, type: :string

      attribute :cash
      attribute :short_term_investments
      attribute :net_receivables
      attribute :inventory
      attribute :other_current_assets
      attribute :total_current_assets

      attribute :long_term_investments
      attribute :property_plant_equipment
      attribute :goodwill, json_key: "goodWill"
      attribute :intangible_assets
      attribute :other_assets
      attribute :total_assets

      attribute :accounts_payable
      attribute :short_long_term_debt
      attribute :other_current_liabilities, json_key: "otherCurrentLiab"
      attribute :total_current_liabilities
      attribute :long_term_debt
      attribute :other_liabilities, json_key: "otherLiab"
      attribute :total_liabilities, json_key: "totalLiab"

      attribute :common_stock
      attribute :retained_earnings
      attribute :treasury_stock
      attribute :other_stockholder_equity
      attribute :total_stockholder_equity
      attribute :net_tangible_assets
      attribute :minority_interest
      attribute :capital_surplus
    end
  end
end
