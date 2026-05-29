# frozen_string_literal: true

module Brapi
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def get(path, params: {})
      client.request(:get, path, params: camelize_keys(params))
    end

    # Brapi endpoints that accept a `symbols` query param take a comma-separated
    # list. Accepts a single String, a single Symbol, or any Enumerable of the
    # two; always returns a String.
    def format_symbols(symbols)
      Array(symbols).join(",")
    end

    def camelize_keys(params)
      return params if params.nil? || params.empty?

      params.each_with_object({}) do |(key, value), out|
        out[camelize(key.to_s)] = format_value(value)
      end
    end

    def camelize(snake)
      head, *rest = snake.split("_")
      ([head] + rest.map(&:capitalize)).join
    end

    def format_value(value)
      case value
      when Array then value.join(",")
      when true  then "true"
      when false then "false"
      else value
      end
    end
  end
end
