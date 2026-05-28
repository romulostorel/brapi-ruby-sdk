# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class Pagination < Brapi::Model
        attribute :page, type: :integer
        attribute :limit, type: :integer
        attribute :total_items, type: :integer
        attribute :total_pages, type: :integer
        attribute :has_next_page, type: :boolean
      end
    end
  end
end
