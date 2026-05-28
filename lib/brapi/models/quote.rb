# frozen_string_literal: true

module Brapi
  module Models
    class Quote < Brapi::Model
      attribute :symbol, type: :string
      attribute :short_name, type: :string
      attribute :long_name, type: :string
      attribute :currency, type: :string
      attribute :regular_market_price, type: :float
      attribute :regular_market_day_high, type: :float
      attribute :regular_market_day_low, type: :float
      attribute :regular_market_day_range, type: :string
      attribute :regular_market_change, type: :float
      attribute :regular_market_change_percent, type: :float
      attribute :regular_market_time, type: :time
      attribute :market_cap, type: :integer
      attribute :regular_market_volume, type: :integer
      attribute :regular_market_previous_close, type: :float
      attribute :regular_market_open, type: :float
      attribute :average_daily_volume3_month, type: :integer, json_key: "averageDailyVolume3Month"
      attribute :average_daily_volume10_day, type: :integer, json_key: "averageDailyVolume10Day"
      attribute :fifty_two_week_low_change, type: :float
      attribute :fifty_two_week_low_change_percent, type: :float
      attribute :fifty_two_week_range, type: :string
      attribute :fifty_two_week_high_change, type: :float
      attribute :fifty_two_week_high_change_percent, type: :float
      attribute :fifty_two_week_low, type: :float
      attribute :fifty_two_week_high, type: :float
      attribute :two_hundred_day_average, type: :float
      attribute :two_hundred_day_average_change, type: :float
      attribute :two_hundred_day_average_change_percent, type: :float
      attribute :price_earnings, type: :float
      attribute :earnings_per_share, type: :float
      attribute :logourl, type: :string

      # Fundamental module slots (typed)
      attribute :summary_profile, type: Brapi::Models::SummaryProfile
      attribute :balance_sheet_history, type: [Brapi::Models::BalanceSheetEntry]
      attribute :balance_sheet_history_quarterly, type: [Brapi::Models::BalanceSheetEntry]
      attribute :default_key_statistics, type: Brapi::Models::KeyStatisticsEntry
      attribute :default_key_statistics_history, type: [Brapi::Models::KeyStatisticsEntry]
      attribute :default_key_statistics_history_quarterly, type: [Brapi::Models::KeyStatisticsEntry]
      attribute :income_statement_history, type: [Brapi::Models::IncomeStatementEntry]
      attribute :income_statement_history_quarterly, type: [Brapi::Models::IncomeStatementEntry]
      attribute :financial_data, type: Brapi::Models::FinancialDataEntry
      attribute :financial_data_history, type: [Brapi::Models::FinancialDataEntry]
      attribute :financial_data_history_quarterly, type: [Brapi::Models::FinancialDataEntry]
      attribute :value_added_history, type: [Brapi::Models::ValueAddedEntry]
      attribute :value_added_history_quarterly, type: [Brapi::Models::ValueAddedEntry]
      attribute :cashflow_history, type: [Brapi::Models::CashflowEntry]
      attribute :cashflow_history_quarterly, type: [Brapi::Models::CashflowEntry]

      # Historical price data — returned when `range`/`interval` are passed.
      attribute :used_interval, type: :string
      attribute :used_range, type: :string
      attribute :valid_intervals
      attribute :valid_ranges
      attribute :historical_data_price, type: [Brapi::Models::HistoricalDataPrice]

      # Dividends — returned when `dividends=true`.
      attribute :dividends_data, type: Brapi::Models::DividendsData
    end
  end
end
