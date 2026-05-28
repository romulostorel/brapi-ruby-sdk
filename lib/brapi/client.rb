# frozen_string_literal: true

require "faraday"
require "faraday/retry"

module Brapi
  class Client
    attr_reader :token, :base_url, :timeout, :open_timeout, :user_agent, :adapter

    def initialize(token: nil, base_url: nil, timeout: nil, open_timeout: nil, user_agent: nil, adapter: nil)
      config = Brapi.configuration
      @token = token || config.token
      @base_url = base_url || config.base_url
      @timeout = timeout || config.timeout
      @open_timeout = open_timeout || config.open_timeout
      @user_agent = user_agent || config.user_agent
      @adapter = adapter || config.adapter
    end

    def connection
      @connection ||= Faraday.new(url: base_url) do |f|
        f.headers["User-Agent"] = user_agent
        f.headers["Authorization"] = "Bearer #{token}" if token && !token.empty?
        f.headers["Accept"] = "application/json"

        f.request :retry,
                  max: 2,
                  interval: 0.5,
                  backoff_factor: 2,
                  retry_statuses: [502, 503, 504],
                  methods: [:get]
        f.response :json, content_type: /\bjson$/

        f.options.timeout = timeout
        f.options.open_timeout = open_timeout

        if adapter
          f.adapter(*Array(adapter))
        else
          f.adapter Faraday.default_adapter
        end
      end
    end

    def request(method, path, params: {})
      response = connection.public_send(method, path) do |req|
        req.params.update(params.compact) if params && !params.empty?
      end
      handle_response(response)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
      raise Brapi::ConnectionError, e.message
    end

    def quote
      @quote ||= Brapi::Resources::Quote.new(self)
    end

    def available
      @available ||= Brapi::Resources::Available.new(self)
    end

    def v2
      @v2 ||= Brapi::Resources::V2.new(self)
    end

    private

    def handle_response(response)
      return response.body if (200..299).cover?(response.status)

      error_class = Brapi::ERROR_BY_STATUS[response.status] || default_error_class(response.status)
      message = extract_message(response.body) || "HTTP #{response.status}"

      if error_class == Brapi::RateLimitError
        raise error_class.new(
          message,
          status: response.status,
          response_body: response.body,
          raw_response: response,
          retry_after: response.headers["retry-after"]&.to_i
        )
      end

      raise error_class.new(
        message,
        status: response.status,
        response_body: response.body,
        raw_response: response
      )
    end

    def default_error_class(status)
      status >= 500 ? Brapi::ServerError : Brapi::Error
    end

    def extract_message(body)
      return nil unless body.is_a?(Hash)

      body["message"] || body["error"] || body.dig("error", "message")
    end
  end
end
