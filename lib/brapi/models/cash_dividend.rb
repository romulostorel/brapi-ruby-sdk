# frozen_string_literal: true

module Brapi
  module Models
    class CashDividend < Brapi::Model
      attribute :asset_issued, type: :string
      attribute :payment_date, type: :time
      attribute :rate, type: :float
      attribute :related_to, type: :string
      attribute :approved_on, type: :time
      attribute :isin_code, type: :string
      attribute :label, type: :string
      attribute :last_date_prior, type: :time
      attribute :remarks, type: :string
    end
  end
end
