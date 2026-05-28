# frozen_string_literal: true

module Brapi
  class Configuration
    DEFAULT_BASE_URL = "https://brapi.dev"
    DEFAULT_TIMEOUT = 30
    DEFAULT_OPEN_TIMEOUT = 10

    attr_accessor :token, :base_url, :timeout, :open_timeout, :user_agent, :adapter

    def initialize
      @token = nil
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @open_timeout = DEFAULT_OPEN_TIMEOUT
      @user_agent = "brapi-ruby-sdk/#{Brapi::VERSION}"
      @adapter = nil
    end
  end
end
