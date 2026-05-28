# frozen_string_literal: true

module Brapi
  module Models
    class SummaryProfile < Brapi::Model
      attribute :address1, type: :string
      attribute :address2, type: :string
      attribute :address3, type: :string
      attribute :city, type: :string
      attribute :state, type: :string
      attribute :zip, type: :string
      attribute :country, type: :string
      attribute :phone, type: :string
      attribute :fax, type: :string
      attribute :website, type: :string
      attribute :industry, type: :string
      attribute :industry_key, type: :string
      attribute :industry_disp, type: :string
      attribute :sector, type: :string
      attribute :sector_key, type: :string
      attribute :sector_disp, type: :string
      attribute :long_business_summary, type: :string
      attribute :full_time_employees, type: :integer
      attribute :company_officers
      attribute :twitter, type: :string
      attribute :name, type: :string
      attribute :start_date, type: :string
      attribute :description, type: :string
      attribute :logo_url, type: :string
      attribute :cnpj, type: :string

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
    end
  end
end
