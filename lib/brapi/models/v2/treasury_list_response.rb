# frozen_string_literal: true

module Brapi
  module Models
    module V2
      class TreasuryListResponse < Brapi::Model
        attribute :results, type: [Brapi::Models::V2::TreasuryBond]
        attribute :pagination, type: Brapi::Models::Pagination
        attribute :requested_at, type: :time
        attribute :took, type: :integer
      end
    end
  end
end
