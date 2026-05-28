# frozen_string_literal: true

module Brapi
  module Models
    class IncomeStatementEntry < Brapi::Model
      attribute :type, type: :string
      attribute :end_date, type: :string
      attribute :total_revenue
      attribute :cost_of_revenue
      attribute :gross_profit
      attribute :research_development
      attribute :selling_general_administrative
      attribute :non_recurring
      attribute :other_operating_expenses
      attribute :total_operating_expenses
      attribute :operating_income
      attribute :total_other_income_expense_net
      attribute :ebit
      attribute :interest_expense
      attribute :income_before_tax
      attribute :income_tax_expense
      attribute :minority_interest
      attribute :net_income_from_continuing_ops
      attribute :discontinued_operations
      attribute :extraordinary_items
      attribute :effect_of_accounting_charges
      attribute :other_items
      attribute :net_income
      attribute :net_income_applicable_to_common_shares
      attribute :sales_expenses
      attribute :losses_due_to_non_recoverability_of_assets
      attribute :other_operating_income
      attribute :equity_income_result
      attribute :financial_result
      attribute :financial_income
      attribute :financial_expenses
      attribute :current_taxes
      attribute :deferred_taxes
      attribute :income_before_statutory_participations_and_contributions
      attribute :basic_earnings_per_common_share, type: :float
      attribute :diluted_earnings_per_common_share, type: :float
      attribute :basic_earnings_per_preferred_share, type: :float
      attribute :profit_sharing_and_statutory_contributions
      attribute :diluted_earnings_per_preferred_share, type: :float
      attribute :claims_and_operations_costs
      attribute :administrative_costs
      attribute :other_operating_income_and_expenses
      attribute :earnings_per_share, type: :float
      attribute :basic_earnings_per_share, type: :float
      attribute :diluted_earnings_per_share, type: :float
      attribute :insurance_operations
      attribute :reinsurance_operations
      attribute :complementary_pension_operations
      attribute :capitalization_operations
      attribute :clean_ebit
      attribute :clean_ebitda
      attribute :clean_nopat
      attribute :clean_net_income
    end
  end
end
