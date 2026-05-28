# frozen_string_literal: true

module Brapi
  module Models
    class StockDividend < Brapi::Model
      attribute :asset_issued, type: :string
      attribute :factor, type: :float
      attribute :complete_factor, type: :string
      attribute :approved_on, type: :time
      attribute :isin_code, type: :string
      attribute :label, type: :string
      attribute :last_date_prior, type: :time
      attribute :remarks, type: :string
    end
  end
end
