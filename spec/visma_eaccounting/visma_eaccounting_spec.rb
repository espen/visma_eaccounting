require 'spec_helper'
require 'cgi'

describe VismaEaccounting do
  describe "attributes" do
    before do
      VismaEaccounting::APIRequest.send(:public, *VismaEaccounting::APIRequest.protected_instance_methods)

      @token = "ifeaean8hfaeo8AUfenao(ea"
      @proxy = 'the_proxy'
    end

    it "have no API by default" do
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.token).to be_nil
    end

    it "sets an API key in the constructor" do
      @visma_eaccounting = VismaEaccounting::Request.new(token: @token)
      expect(@visma_eaccounting.token).to eq(@token)
    end

    it "sets an API key via setter" do
      @visma_eaccounting = VismaEaccounting::Request.new
      @visma_eaccounting.token = @token
      expect(@visma_eaccounting.token).to eq(@token)
    end

    it "sets timeout and get" do
      @visma_eaccounting = VismaEaccounting::Request.new
      timeout = 30
      @visma_eaccounting.timeout = timeout
      expect(timeout).to eq(@visma_eaccounting.timeout)
    end

    it "sets the open_timeout and get" do
      @visma_eaccounting = VismaEaccounting::Request.new
      open_timeout = 30
      @visma_eaccounting.open_timeout = open_timeout
      expect(open_timeout).to eq(@visma_eaccounting.open_timeout)
    end

    it "timeout properly passed to APIRequest" do
      @visma_eaccounting = VismaEaccounting::Request.new
      timeout = 30
      @visma_eaccounting.timeout = timeout
      @request = VismaEaccounting::APIRequest.new(builder: @visma_eaccounting)
      expect(timeout).to eq(@request.timeout)
    end

    it "timeout properly based on open_timeout passed to APIRequest" do
      @visma_eaccounting = VismaEaccounting::Request.new
      open_timeout = 30
      @visma_eaccounting.open_timeout = open_timeout
      @request = VismaEaccounting::APIRequest.new(builder: @visma_eaccounting)
      expect(open_timeout).to eq(@request.open_timeout)
    end

    it "has no Proxy url by default" do
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.proxy).to be_nil
    end

    it "sets an proxy url key from the 'VISMA_PROXY_URL' ENV variable" do
      ENV['VISMA_PROXY_URL'] = @proxy
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.proxy).to eq(@proxy)
      ENV.delete('VISMA_PROXY_URL')
    end

    it "sets an API key via setter" do
      @visma_eaccounting = VismaEaccounting::Request.new
      @visma_eaccounting.proxy = @proxy
      expect(@visma_eaccounting.proxy).to eq(@proxy)
    end

    it "sets an adapter in the constructor" do
      adapter = :em_synchrony
      @visma_eaccounting = VismaEaccounting::Request.new(faraday_adapter: adapter)
      expect(@visma_eaccounting.faraday_adapter).to eq(adapter)
    end

    it "symbolize_keys false by default" do
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.symbolize_keys).to be false
    end

    it "sets symbolize_keys in the constructor" do
      @visma_eaccounting = VismaEaccounting::Request.new(symbolize_keys: true)
      expect(@visma_eaccounting.symbolize_keys).to be true
    end

    it "sets symbolize_keys in the constructor" do
      @visma_eaccounting = VismaEaccounting::Request.new(symbolize_keys: true)
      expect(@visma_eaccounting.symbolize_keys).to be true
    end

    it "debug false by default" do
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.debug).to be false
    end

    it "sets debug in the constructor" do
      @visma_eaccounting = VismaEaccounting::Request.new(debug: true)
      expect(@visma_eaccounting.debug).to be true
    end

    it "sets logger in constructor" do
      logger = double(:logger)
      @visma_eaccounting = VismaEaccounting::Request.new(logger: logger)
      expect(@visma_eaccounting.logger).to eq(logger)
    end

    it "is a Logger instance by default" do
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.logger).to be_a Logger
    end

    it "api_environment production by default" do
      @visma_eaccounting = VismaEaccounting::Request.new
      expect(@visma_eaccounting.api_environment).to be :production
    end

    it "sets api_environment in the constructor" do
      @visma_eaccounting = VismaEaccounting::Request.new(api_environment: :sandbox)
      expect(@visma_eaccounting.api_environment).to be :sandbox
    end

  end

  describe "supports different environments" do
    before do
      VismaEaccounting::APIRequest.send(:public, *VismaEaccounting::APIRequest.protected_instance_methods)
    end

    it "has correct api url for default production environment" do
      @visma_eaccounting = VismaEaccounting::Request.new()
      @request = VismaEaccounting::APIRequest.new(builder: @visma_eaccounting)
      expect(@request.send(:base_api_url)).to eq("https://eaccountingapi.vismaonline.com/v2/")
    end

    it "has corret api url when setting sandbox environment" do
      @visma_eaccounting = VismaEaccounting::Request.new(api_environment: :sandbox)
      @request = VismaEaccounting::APIRequest.new(builder: @visma_eaccounting)
      expect(@request.send(:base_api_url)).to eq("https://eaccountingapi-sandbox.test.vismaonline.com/v2/")
    end

  end

  describe "build api url" do
    before do
      VismaEaccounting::APIRequest.send(:public, *VismaEaccounting::APIRequest.protected_instance_methods)

      @visma_eaccounting = VismaEaccounting::Request.new
    end

    it "doesn't allow empty api key" do
      expect {@visma_eaccounting.try.retrieve}.to raise_error(VismaEaccounting::VismaEaccountingError)
    end

  end

  describe "class variables" do
    let(:logger) { double(:logger) }

    before do
      VismaEaccounting::Request.token = "ifeaean8hfaeo8AUfenao(ea"
      VismaEaccounting::Request.timeout = 15
      VismaEaccounting::Request.api_environment = :sandbox
      VismaEaccounting::Request.api_endpoint = 'https://eaccountingapi.example.org/v1337/'
      VismaEaccounting::Request.logger = logger
      VismaEaccounting::Request.proxy = "http://1234.com"
      VismaEaccounting::Request.symbolize_keys = true
      VismaEaccounting::Request.faraday_adapter = :net_http
      VismaEaccounting::Request.debug = true
    end

    after do
      VismaEaccounting::Request.token = nil
      VismaEaccounting::Request.timeout = nil
      VismaEaccounting::Request.api_environment = nil
      VismaEaccounting::Request.api_endpoint = nil
      VismaEaccounting::Request.logger = nil
      VismaEaccounting::Request.proxy = nil
      VismaEaccounting::Request.symbolize_keys = nil
      VismaEaccounting::Request.faraday_adapter = nil
      VismaEaccounting::Request.debug = nil
    end

    it "set api key on new instances" do
      expect(VismaEaccounting::Request.new.token).to eq(VismaEaccounting::Request.token)
    end

    it "set timeout on new instances" do
      expect(VismaEaccounting::Request.new.timeout).to eq(VismaEaccounting::Request.timeout)
    end

    it "set api_environment on new instances" do
      expect(VismaEaccounting::Request.api_environment).not_to be_nil
      expect(VismaEaccounting::Request.new.api_environment).to eq(VismaEaccounting::Request.api_environment)
    end

    it "set api_endpoint on new instances" do
      expect(VismaEaccounting::Request.api_endpoint).not_to be_nil
      expect(VismaEaccounting::Request.new.api_endpoint).to eq(VismaEaccounting::Request.api_endpoint)
    end

    it "set proxy on new instances" do
      expect(VismaEaccounting::Request.new.proxy).to eq(VismaEaccounting::Request.proxy)
    end

    it "set symbolize_keys on new instances" do
      expect(VismaEaccounting::Request.new.symbolize_keys).to eq(VismaEaccounting::Request.symbolize_keys)
    end

    it "set debug on new instances" do
      expect(VismaEaccounting::Request.new.debug).to eq(VismaEaccounting::Request.debug)
    end

    it "set faraday_adapter on new instances" do
      expect(VismaEaccounting::Request.new.faraday_adapter).to eq(VismaEaccounting::Request.faraday_adapter)
    end

    it "set logger on new instances" do
      expect(VismaEaccounting::Request.new.logger).to eq(logger)
    end
  end

  describe "missing methods" do
    it "respond to .method call on class" do
      expect(VismaEaccounting::Request.method(:customers)).to be_a(Method)
    end
    it "respond to .method call on instance" do
      expect(VismaEaccounting::Request.new.method(:customers)).to be_a(Method)
    end
  end
end
