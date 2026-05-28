# frozen_string_literal: true

module Brapi
  module Models
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
