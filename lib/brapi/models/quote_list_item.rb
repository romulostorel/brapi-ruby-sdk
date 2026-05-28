# frozen_string_literal: true

module Brapi
  module Models
    class QuoteListItem < Brapi::Model
      attribute :stock, type: :string
      attribute :name, type: :string
      attribute :close, type: :float
      attribute :change, type: :float
      attribute :volume, type: :integer
      attribute :market_cap, type: :integer
      attribute :logo, type: :string
      attribute :sector, type: :string
      attribute :type, type: :string
    end
  end
end
