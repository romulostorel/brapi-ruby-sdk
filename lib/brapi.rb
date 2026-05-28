# frozen_string_literal: true

require "brapi/version"
require "brapi/configuration"
require "brapi/errors"
require "brapi/model"
require "brapi/resource"

# Models — order matters: leaf classes before composite ones.
require "brapi/models/balance_sheet_entry"
require "brapi/models/financial_data_entry"
require "brapi/models/quote"
require "brapi/models/quote_retrieve_response"
require "brapi/models/quote_list_item"
require "brapi/models/quote_list_response"
require "brapi/models/available_list_response"

require "brapi/models/v2/crypto"
require "brapi/models/v2/crypto_retrieve_response"
require "brapi/models/v2/crypto_list_available_response"

require "brapi/models/v2/currency"
require "brapi/models/v2/currency_retrieve_response"
require "brapi/models/v2/currency_list_available_response"

require "brapi/models/v2/inflation_entry"
require "brapi/models/v2/inflation_retrieve_response"
require "brapi/models/v2/inflation_list_available_response"

require "brapi/models/v2/prime_rate_entry"
require "brapi/models/v2/prime_rate_retrieve_response"
require "brapi/models/v2/prime_rate_list_available_response"

# Resources — v2 (parent class) must load before its nested classes
require "brapi/resources/quote"
require "brapi/resources/available"
require "brapi/resources/v2"
require "brapi/resources/v2/crypto"
require "brapi/resources/v2/currency"
require "brapi/resources/v2/inflation"
require "brapi/resources/v2/prime_rate"

require "brapi/client"

module Brapi
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
      @client = nil
    end

    def client
      @client ||= Client.new
    end

    def reset_client!
      @client = nil
    end

    def quote
      client.quote
    end

    def available
      client.available
    end

    def v2
      client.v2
    end
  end
end
