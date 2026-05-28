# frozen_string_literal: true

module Brapi
  module Models
    class BalanceSheetEntry < Brapi::Model
      attribute :end_date, type: :string
      attribute :cash
      attribute :short_term_investments
      attribute :net_receivables
      attribute :inventory
      attribute :other_current_assets
      attribute :total_current_assets
      attribute :long_term_investments
      attribute :property_plant_equipment
      attribute :goodwill
      attribute :intangible_assets
      attribute :other_assets
      attribute :total_assets
      attribute :accounts_payable
      attribute :short_long_term_debt
      attribute :other_current_liabilities
      attribute :total_current_liabilities
      attribute :long_term_debt
      attribute :other_liabilities
      attribute :total_liabilities
      attribute :common_stock
      attribute :retained_earnings
      attribute :treasury_stock
      attribute :other_stockholder_equity
      attribute :total_stockholder_equity
      attribute :net_tangible_assets
    end
  end
end
