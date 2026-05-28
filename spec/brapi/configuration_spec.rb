# frozen_string_literal: true

RSpec.describe Brapi::Configuration do
  it "defaults to brapi.dev base URL" do
    expect(described_class.new.base_url).to eq("https://brapi.dev")
  end

  it "defaults to 30s timeout and 10s open timeout" do
    config = described_class.new
    expect(config.timeout).to eq(30)
    expect(config.open_timeout).to eq(10)
  end

  it "has a User-Agent reporting the SDK version" do
    expect(described_class.new.user_agent).to eq("brapi-ruby-sdk/#{Brapi::VERSION}")
  end

  it "allows overriding all attributes" do
    config = described_class.new
    config.token = "tok"
    config.base_url = "https://example.com"
    config.timeout = 5
    config.open_timeout = 2
    config.user_agent = "my-app/1.0"
    config.adapter = :test

    expect(config.token).to eq("tok")
    expect(config.base_url).to eq("https://example.com")
    expect(config.timeout).to eq(5)
    expect(config.open_timeout).to eq(2)
    expect(config.user_agent).to eq("my-app/1.0")
    expect(config.adapter).to eq(:test)
  end
end
