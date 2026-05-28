# frozen_string_literal: true

require_relative "lib/brapi/version"

Gem::Specification.new do |spec|
  spec.name = "brapi"
  spec.version = Brapi::VERSION
  spec.authors = ["Rômulo Storel"]
  spec.email = ["romulo.storel@codeminer42.com"]

  spec.summary = "Ruby SDK for brapi.dev — Brazilian financial market API"
  spec.description = "Idiomatic Ruby client for the brapi.dev API, providing access to Brazilian stocks, " \
                     "cryptocurrencies, currency exchange rates, inflation and prime rate (SELIC) data."
  spec.homepage = "https://github.com/romulostorel/brapi-ruby-sdk"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"
end
