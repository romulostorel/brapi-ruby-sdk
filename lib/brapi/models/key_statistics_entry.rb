# frozen_string_literal: true

module Brapi
  module Models
    # Used for both `defaultKeyStatistics` (single TTM object, no type/end_date)
    # and `defaultKeyStatisticsHistory[*]` (array of annual entries) and the
    # quarterly variant. Fields not present in a given payload come back nil.
    class KeyStatisticsEntry < Brapi::Model
      attribute :type, type: :string
      attribute :end_date, type: :string
      attribute :price_hint
      attribute :price
      attribute :enterprise_value
      attribute :forward_pe, type: :float, json_key: "forwardPE"
      attribute :profit_margins, type: :float
      attribute :float_shares
      attribute :shares_outstanding
      attribute :shares_short
      attribute :shares_short_prior_month
      attribute :shares_short_previous_month_date
      attribute :date_short_interest
      attribute :shares_percent_shares_out, type: :float
      attribute :held_percent_insiders, type: :float
      attribute :held_percent_institutions, type: :float
      attribute :short_ratio, type: :float
      attribute :short_percent_of_float, type: :float
      attribute :beta, type: :float
      attribute :implied_shares_outstanding
      attribute :category, type: :string
      attribute :book_value, type: :float
      attribute :price_to_book, type: :float
      attribute :fund_family, type: :string
      attribute :legal_type, type: :string
      attribute :last_fiscal_year_end
      attribute :next_fiscal_year_end
      attribute :most_recent_quarter
      attribute :earnings_quarterly_growth, type: :float
      attribute :net_income_to_common
      attribute :trailing_eps, type: :float
      attribute :forward_eps, type: :float
      attribute :peg_ratio, type: :float
      attribute :last_split_factor, type: :string
      attribute :last_split_date
      attribute :enterprise_to_revenue, type: :float
      attribute :enterprise_to_ebitda, type: :float
      attribute :fifty_two_week_change, type: :float, json_key: "52WeekChange"
      attribute :sandp_fifty_two_week_change, type: :float, json_key: "SandP52WeekChange"
      attribute :last_dividend_value, type: :float
      attribute :last_dividend_date
      attribute :ytd_return, type: :float
      attribute :beta3_year, type: :float
      attribute :total_assets
      attribute :yield, type: :float
      attribute :fund_inception_date
      attribute :three_year_average_return, type: :float
      attribute :five_year_average_return, type: :float
      attribute :morning_star_overall_rating
      attribute :morning_star_risk_rating
      attribute :annual_report_expense_ratio, type: :float
      attribute :last_cap_gain, type: :float
      attribute :annual_holdings_turnover, type: :float
      attribute :market_cap
      attribute :trailing_pe, type: :float, json_key: "trailingPE"
      attribute :earnings_per_share, type: :float
      attribute :dividend_yield, type: :float
    end
  end
end
