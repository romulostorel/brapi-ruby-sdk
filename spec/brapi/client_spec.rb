# frozen_string_literal: true

RSpec.describe Brapi::Client do
  let(:token) { "test-token" }
  let(:client) { described_class.new(token: token) }

  describe "#initialize" do
    it "uses values from Brapi.configuration as defaults" do
      Brapi.configure do |c|
        c.token = "from-config"
        c.timeout = 7
      end

      client = described_class.new
      expect(client.token).to eq("from-config")
      expect(client.timeout).to eq(7)
    end

    it "lets explicit args override the configuration" do
      Brapi.configure { |c| c.token = "from-config" }
      client = described_class.new(token: "override", timeout: 1)
      expect(client.token).to eq("override")
      expect(client.timeout).to eq(1)
    end
  end

  describe "#request" do
    it "sends the bearer token in the Authorization header" do
      stub_brapi(:get, "/api/quote/PETR4", response_body: { results: [] })
      client.quote.retrieve("PETR4")

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/quote/PETR4")
        .with(headers: { "Authorization" => "Bearer test-token" })
    end

    it "omits Authorization when no token is set" do
      stub_brapi(:get, "/api/quote/PETR4", response_body: { results: [] })
      described_class.new.quote.retrieve("PETR4")

      expect(WebMock).to(have_requested(:get, "https://brapi.dev/api/quote/PETR4")
        .with { |req| !req.headers.key?("Authorization") })
    end

    it "sends a SDK-identifying User-Agent" do
      stub_brapi(:get, "/api/quote/PETR4", response_body: { results: [] })
      client.quote.retrieve("PETR4")

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/quote/PETR4")
        .with(headers: { "User-Agent" => "brapi-ruby-sdk/#{Brapi::VERSION}" })
    end

    it "forwards query params (snake_case keys are camelized)" do
      stub_brapi(:get, "/api/quote/list",
                 query: { sortBy: "volume", sortOrder: "desc", limit: "10" },
                 response_body: { stocks: [] })
      client.quote.list(sort_by: "volume", sort_order: "desc", limit: 10)

      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/quote/list")
        .with(query: { sortBy: "volume", sortOrder: "desc", limit: "10" })
    end
  end

  describe "error mapping" do
    {
      400 => Brapi::BadRequestError,
      401 => Brapi::AuthenticationError,
      402 => Brapi::PaymentRequiredError,
      403 => Brapi::PermissionDeniedError,
      404 => Brapi::NotFoundError,
      500 => Brapi::ServerError,
      503 => Brapi::ServerError
    }.each do |status, klass|
      it "raises #{klass} on HTTP #{status}" do
        stub_brapi(:get, "/api/quote/PETR4", status: status,
                                             response_body: { message: "oops" })
        expect { client.quote.retrieve("PETR4") }.to raise_error(klass) do |err|
          expect(err.status).to eq(status)
          expect(err.message).to eq("oops")
        end
      end
    end

    it "raises RateLimitError with retry_after on 429" do
      stub_brapi(:get, "/api/quote/PETR4", status: 429,
                                           headers: { "Retry-After" => "12" },
                                           response_body: { message: "slow down" })

      expect { client.quote.retrieve("PETR4") }.to raise_error(Brapi::RateLimitError) do |err|
        expect(err.retry_after).to eq(12)
      end
    end

    it "raises ConnectionError on Faraday::ConnectionFailed" do
      stub_request(:get, "https://brapi.dev/api/quote/PETR4")
        .to_raise(Faraday::ConnectionFailed.new("boom"))

      expect { client.quote.retrieve("PETR4") }.to raise_error(Brapi::ConnectionError, /boom/)
    end

    it "retries on 503 (transient server error)" do
      stub_request(:get, "https://brapi.dev/api/quote/PETR4")
        .to_return({ status: 503, body: "{}" }, { status: 200, body: '{"results":[]}' })

      expect { client.quote.retrieve("PETR4") }.not_to raise_error
      expect(WebMock).to have_requested(:get, "https://brapi.dev/api/quote/PETR4").twice
    end
  end

  describe "resource accessors" do
    it "memoizes resources" do
      quote = client.quote
      available = client.available
      v2 = client.v2
      crypto = v2.crypto

      expect(client.quote).to be(quote)
      expect(client.available).to be(available)
      expect(client.v2).to be(v2)
      expect(client.v2.crypto).to be(crypto)
    end
  end
end
