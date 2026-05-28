# frozen_string_literal: true

require "brapi/version"
require "brapi/configuration"
require "brapi/errors"
require "brapi/model"
require "brapi/resource"

# Models — leaf classes first, composite classes after.
require "brapi/models/balance_sheet_entry"
require "brapi/models/financial_data_entry"
require "brapi/models/income_statement_entry"
require "brapi/models/cashflow_entry"
require "brapi/models/value_added_entry"
require "brapi/models/key_statistics_entry"
require "brapi/models/summary_profile"
require "brapi/models/historical_data_price"
require "brapi/models/cash_dividend"
require "brapi/models/stock_dividend"
require "brapi/models/subscription"
require "brapi/models/dividends_data"

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

require "brapi/models/v2/pagination"

require "brapi/models/v2/fii"
require "brapi/models/v2/fii_dividend"
require "brapi/models/v2/fii_history"
require "brapi/models/v2/fii_list_response"
require "brapi/models/v2/fii_indicators_response"
require "brapi/models/v2/fii_historical_response"
require "brapi/models/v2/fii_dividends_response"

require "brapi/models/v2/macro_series"
require "brapi/models/v2/macro_observation"
require "brapi/models/v2/macro_result"
require "brapi/models/v2/macro_retrieve_response"
require "brapi/models/v2/macro_list_available_response"

require "brapi/models/v2/treasury_rate_info"
require "brapi/models/v2/treasury_bond"
require "brapi/models/v2/treasury_list_response"
require "brapi/models/v2/treasury_indicators_response"

# Resources — v2 (parent class) must load before its nested classes
require "brapi/resources/quote"
require "brapi/resources/available"
require "brapi/resources/v2"
require "brapi/resources/v2/crypto"
require "brapi/resources/v2/currency"
require "brapi/resources/v2/inflation"
require "brapi/resources/v2/prime_rate"
require "brapi/resources/v2/fii"
require "brapi/resources/v2/macro"
require "brapi/resources/v2/treasury"

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
