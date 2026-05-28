# frozen_string_literal: true

module Brapi
  module Models
    class QuoteListResponse < Brapi::Model
      attribute :indexes
      attribute :stocks, type: [Brapi::Models::QuoteListItem]
      attribute :available_sectors
      attribute :available_stock_types
      attribute :current_page, type: :integer
      attribute :total_pages, type: :integer
      attribute :item_count, type: :integer
      attribute :has_next_page, type: :boolean
    end
  end
end
