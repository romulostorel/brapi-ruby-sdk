# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class FiiDividend < Brapi::Model
        attribute :symbol, type: :string
        attribute :label, type: :string
        attribute :rate, type: :float
        attribute :related_to, type: :string
        attribute :approved_on, type: :time
        attribute :last_date_prior, type: :time
        attribute :payment_date, type: :time
        attribute :isin_code, type: :string
        attribute :remarks, type: :string
      end
    end
  end
end
