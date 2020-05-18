require 'spec_helper'
require 'webmock/rspec'

describe VismaEaccounting::APIRequest do
  let(:token) { "ionfean8hfaeo8AUfenao(ea" }

  before do
    @visma_eaccounting = VismaEaccounting::Request.new(token: token)
    @api_root = "https://eaccountingapi.vismaonline.com/v2"
  end

  it "surfaces client request exceptions as a VismaEaccounting::APIError" do
    exception = Faraday::ClientError.new("the server responded with status 503")
    stub_request(:get, "#{@api_root}/customers").to_raise(exception)
    expect { @visma_eaccounting.customers.retrieve }.to raise_error(VismaEaccounting::APIError)
  end

  it "surfaces an unparseable client request exception as a VismaEaccounting::APIError" do
    exception = Faraday::ClientError.new(
      "the server responded with status 503")
    stub_request(:get, "#{@api_root}/customers").to_raise(exception)
    expect { @visma_eaccounting.customers.retrieve }.to raise_error(VismaEaccounting::APIError)
  end

  it "surfaces an unparseable response body as a VismaEaccounting::APIError" do
    response_values = {:status => 503, :headers => {}, :body => '[foo]'}
    exception = Faraday::ClientError.new("the server responded with status 503", response_values)

    stub_request(:get, "#{@api_root}/customers").to_raise(exception)
    expect { @visma_eaccounting.customers.retrieve }.to raise_error(VismaEaccounting::APIError)
  end

  context "handle_error" do
    it "includes status and raw body even when json can't be parsed" do
      response_values = {:status => 503, :headers => {}, :body => 'A non JSON response'}
      exception = Faraday::ClientError.new("the server responded with status 503", response_values)
      api_request = VismaEaccounting::APIRequest.new(builder: VismaEaccounting::Request)
      begin
        api_request.send :handle_error, exception
      rescue => boom
        expect(boom.status_code).to eq 503
        expect(boom.raw_body).to eq "A non JSON response"
      end
    end

    context "when symbolize_keys is true" do
      it "sets title and detail on the error params" do
        response_values = {:status => 422, :headers => {}, :body => '{"title": "foo", "detail": "bar"}'}
        exception = Faraday::ClientError.new("the server responded with status 422", response_values)
        api_request = VismaEaccounting::APIRequest.new(builder: VismaEaccounting::Request.new(symbolize_keys: true))
        begin
          api_request.send :handle_error, exception
        rescue => boom
          expect(boom.title).to eq "foo"
          expect(boom.detail).to eq "bar"
        end
      end
    end
  end
end
