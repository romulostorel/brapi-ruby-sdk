# frozen_string_literal: true

RSpec.describe Brapi do
  describe ".configure" do
    it "yields the configuration object" do
      described_class.configure do |c|
        c.token = "abc"
        c.timeout = 9
      end

      expect(described_class.configuration.token).to eq("abc")
      expect(described_class.configuration.timeout).to eq(9)
    end
  end

  describe ".configuration" do
    it "returns the same Configuration instance across calls" do
      first = described_class.configuration
      second = described_class.configuration
      expect(first).to be(second)
    end

    it "exposes defaults" do
      expect(described_class.configuration.base_url).to eq("https://brapi.dev")
      expect(described_class.configuration.timeout).to eq(30)
      expect(described_class.configuration.user_agent).to include("brapi-ruby-sdk/")
    end
  end

  describe ".reset_configuration!" do
    it "resets back to defaults and discards memoized client" do
      described_class.configure { |c| c.token = "x" }
      described_class.client
      described_class.reset_configuration!

      expect(described_class.configuration.token).to be_nil
      expect(described_class.instance_variable_get(:@client)).to be_nil
    end
  end

  describe ".client" do
    it "returns a memoized Brapi::Client instance" do
      a = described_class.client
      b = described_class.client
      expect(a).to be_a(Brapi::Client).and(be(b))
    end
  end

  describe ".quote / .available / .v2" do
    it "delegates to the singleton client" do
      expect(described_class.quote).to be_a(Brapi::Resources::Quote)
      expect(described_class.available).to be_a(Brapi::Resources::Available)
      expect(described_class.v2).to be_a(Brapi::Resources::V2)
    end
  end
end
