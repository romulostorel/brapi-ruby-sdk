# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class MacroSeries < Brapi::Model
        attribute :slug, type: :string
        attribute :name, type: :string
        attribute :description, type: :string
        attribute :unit, type: :string
        attribute :frequency, type: :string
        attribute :category, type: :string
        attribute :start_date, type: :string
      end
    end
  end
end
