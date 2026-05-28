# frozen_string_literal: true

module Brapi
  module Models
    # NOTE: field list is inferred from CashDividend / StockDividend shape — the
    # brapi `subscriptions` payload captured during v0.2 development was empty.
    # If the live API returns different keys, attribute readers will return nil
    # silently; `Model#raw` still exposes the original Hash. Update fields once
    # a real payload is observed.
    class Subscription < Brapi::Model
      attribute :asset_issued, type: :string
      attribute :factor, type: :float
      attribute :price_unit, type: :float
      attribute :approved_on, type: :time
      attribute :isin_code, type: :string
      attribute :label, type: :string
      attribute :last_date_prior, type: :time
      attribute :subscription_date, type: :time
      attribute :remarks, type: :string
    end
  end
end
