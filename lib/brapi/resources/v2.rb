# frozen_string_literal: true

module Brapi
  module Resources
    class V2
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def crypto
        @crypto ||= Brapi::Resources::V2::Crypto.new(client)
      end

      def currency
        @currency ||= Brapi::Resources::V2::Currency.new(client)
      end

      def inflation
        @inflation ||= Brapi::Resources::V2::Inflation.new(client)
      end

      def prime_rate
        @prime_rate ||= Brapi::Resources::V2::PrimeRate.new(client)
      end

      def fii
        @fii ||= Brapi::Resources::V2::Fii.new(client)
      end

      def macro
        @macro ||= Brapi::Resources::V2::Macro.new(client)
      end

      def treasury
        @treasury ||= Brapi::Resources::V2::Treasury.new(client)
      end
    end
  end
end
