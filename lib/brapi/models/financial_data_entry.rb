# frozen_string_literal: true

module Brapi
  module Models
    # Backs both `financialData` (single TTM object, no type/end_date)
    # and `financialDataHistory[*]` (annual/quarterly array entries).
    class FinancialDataEntry < Brapi::Model
      attribute :type, type: :string
      attribute :end_date, type: :string
      attribute :current_price, type: :float
      attribute :total_revenue
      attribute :revenue_per_share, type: :float
      attribute :gross_profits
      attribute :ebitda
      attribute :operating_cashflow
      attribute :free_cashflow
      attribute :total_cash
      attribute :total_cash_per_share, type: :float
      attribute :total_debt
      attribute :debt_to_equity, type: :float
      attribute :current_ratio, type: :float
      attribute :quick_ratio, type: :float
      attribute :return_on_assets, type: :float
      attribute :return_on_equity, type: :float
      attribute :gross_margins, type: :float
      attribute :ebitda_margins, type: :float
      attribute :operating_margins, type: :float
      attribute :profit_margins, type: :float
      attribute :earnings_growth, type: :float
      attribute :revenue_growth, type: :float
      attribute :earnings_growth_annual, type: :float
      attribute :revenue_growth_annual, type: :float
      attribute :financial_currency, type: :string
    end
  end
end
