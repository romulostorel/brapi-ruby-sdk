# frozen_string_literal: true

require "brapi/version"
require "brapi/configuration"
require "brapi/errors"
require "brapi/model"
require "brapi/resource"
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
  end
end
