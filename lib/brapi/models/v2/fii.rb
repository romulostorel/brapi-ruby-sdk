# frozen_string_literal: true

module Brapi
  module Models
    module V2
      # Single class backing both /api/v2/fii/list (basic info) and
      # /api/v2/fii/indicators (basic info + current indicators).
      # Indicator-only fields come back nil from the list endpoint.
      class Fii < Brapi::Model
        attribute :symbol, type: :string
        attribute :name, type: :string
        attribute :cnpj, type: :string
        attribute :mandate, type: :string
        attribute :segmento_atuacao, type: :string
        attribute :tipo_gestao, type: :string
        attribute :segment_type, type: :string

        attribute :administrator_name, type: :string
        attribute :administrator_cnpj, type: :string
        attribute :administrator_address, type: :string
        attribute :administrator_address_number, type: :string
        attribute :administrator_address_complement, type: :string
        attribute :administrator_district, type: :string
        attribute :administrator_city, type: :string
        attribute :administrator_state, type: :string
        attribute :administrator_zip_code, type: :string
        attribute :administrator_phone1, type: :string
        attribute :administrator_phone2, type: :string
        attribute :administrator_phone3, type: :string
        attribute :administrator_website, type: :string
        attribute :administrator_email, type: :string

        attribute :price, type: :float
        attribute :nav_per_share, type: :float
        attribute :price_to_nav, type: :float
        attribute :dividend_yield12m, type: :float, json_key: "dividendYield12m"
        attribute :total_investors, type: :integer

        # Indicators-only fields (nil when returned by /fii/list)
        attribute :as_of_date, type: :string
        attribute :dividend_yield1m, type: :float, json_key: "dividendYield1m"
        attribute :monthly_return, type: :float
        attribute :shares_outstanding, type: :integer
        attribute :equity
        attribute :total_assets
      end
    end
  end
end
