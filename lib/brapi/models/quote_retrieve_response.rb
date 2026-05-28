# frozen_string_literal: true

module Brapi
  module Models
    class QuoteRetrieveResponse < Brapi::Model
      attribute :results, type: [Brapi::Models::Quote]
      attribute :requested_at, type: :time
      attribute :took, type: :integer
    end
  end
end
