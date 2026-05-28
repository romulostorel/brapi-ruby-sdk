# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

require "brapi"
require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.warnings = false
  config.order = :random
  Kernel.srand config.seed

  config.before do
    Brapi.reset_configuration!
    WebMock.reset!
  end
end

module BrapiSpecHelpers
  def stub_brapi(method, path, query: nil, status: 200, response_body: {}, headers: {})
    stub = stub_request(method, "https://brapi.dev#{path}")
    stub = stub.with(query: query) if query
    stub.to_return(
      status: status,
      body: response_body.is_a?(Hash) || response_body.is_a?(Array) ? JSON.dump(response_body) : response_body,
      headers: { "Content-Type" => "application/json" }.merge(headers)
    )
  end
end

RSpec.configure { |c| c.include BrapiSpecHelpers }
