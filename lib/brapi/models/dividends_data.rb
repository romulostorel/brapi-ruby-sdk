# frozen_string_literal: true

module Brapi
  module Models
    class DividendsData < Brapi::Model
      attribute :cash_dividends, type: [Brapi::Models::CashDividend]
      attribute :stock_dividends, type: [Brapi::Models::StockDividend]
      attribute :subscriptions, type: [Brapi::Models::Subscription]
    end
  end
end
