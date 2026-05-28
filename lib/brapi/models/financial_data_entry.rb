# frozen_string_literal: true

module Brapi
  module Models
    class FinancialDataEntry < Brapi::Model
      attribute :end_date, type: :string
      attribute :total_revenue
      attribute :revenue_per_share
      attribute :gross_profits
      attribute :ebitda
      attribute :operating_cashflow
      attribute :free_cashflow
      attribute :total_cash
      attribute :total_cash_per_share
      attribute :total_debt
      attribute :debt_to_equity
      attribute :current_ratio
      attribute :quick_ratio
      attribute :return_on_assets
      attribute :return_on_equity
      attribute :gross_margins
      attribute :ebitda_margins
      attribute :operating_margins
      attribute :profit_margins
      attribute :earnings_growth
      attribute :revenue_growth
      attribute :financial_currency
    end
  end
end
