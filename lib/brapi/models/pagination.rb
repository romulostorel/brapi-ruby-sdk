# frozen_string_literal: true

module Brapi
  module Models
    # Pagination metadata returned by paginated brapi endpoints
    # (e.g. /api/v2/fii/list, /api/v2/treasury/list, /api/quote/list).
    class Pagination < Brapi::Model
      attribute :page, type: :integer
      attribute :limit, type: :integer
      attribute :total_items, type: :integer
      attribute :total_pages, type: :integer
      attribute :has_next_page, type: :boolean
    end
  end
end
