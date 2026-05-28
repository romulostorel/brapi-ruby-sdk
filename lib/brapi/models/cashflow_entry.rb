# frozen_string_literal: true

module Brapi
  module Models
    class CashflowEntry < Brapi::Model
      attribute :type, type: :string
      attribute :end_date, type: :string
      attribute :operating_cash_flow
      attribute :income_from_operations
      attribute :net_income_before_taxes
      attribute :adjustments_to_profit_or_loss
      attribute :changes_in_assets_and_liabilities
      attribute :other_operating_activities
      attribute :cash_generated_in_operations
      attribute :investment_cash_flow
      attribute :financing_cash_flow
      attribute :exchange_variation_without_cash
      attribute :foreign_exchange_rate_without_cash
      attribute :increase_or_decrease_in_cash
      attribute :initial_cash_balance
      attribute :final_cash_balance
      attribute :free_cash_flow
    end
  end
end
