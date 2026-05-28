# frozen_string_literal: true

module Brapi
  class Error < StandardError
    attr_reader :status, :response_body, :raw_response

    def initialize(message = nil, status: nil, response_body: nil, raw_response: nil)
      super(message)
      @status = status
      @response_body = response_body
      @raw_response = raw_response
    end
  end

  class BadRequestError < Error; end
  class AuthenticationError < Error; end
  class PaymentRequiredError < Error; end
  class PermissionDeniedError < Error; end
  class NotFoundError < Error; end
  class ServerError < Error; end
  class ConnectionError < Error; end

  class RateLimitError < Error
    attr_reader :retry_after

    def initialize(message = nil, status: nil, response_body: nil, raw_response: nil, retry_after: nil)
      super(message, status: status, response_body: response_body, raw_response: raw_response)
      @retry_after = retry_after
    end
  end

  ERROR_BY_STATUS = {
    400 => BadRequestError,
    401 => AuthenticationError,
    402 => PaymentRequiredError,
    403 => PermissionDeniedError,
    404 => NotFoundError,
    429 => RateLimitError
  }.freeze
end
