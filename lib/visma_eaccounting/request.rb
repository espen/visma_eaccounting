module VismaEaccounting
  class Request
    attr_accessor :token, :api_environment, :api_endpoint, :timeout, :open_timeout, :proxy, :faraday_adapter, :symbolize_keys, :debug, :logger

    DEFAULT_TIMEOUT = 60
    DEFAULT_OPEN_TIMEOUT = 60
    DEFAULT_API_ENVIRONMENT = :production

    def initialize(token: nil, api_environment: nil, api_endpoint: nil, timeout: nil, open_timeout: nil, proxy: nil, faraday_adapter: nil, symbolize_keys: false, debug: false, logger: nil)
      @path_parts = []
      @token = token || self.class.token
      @token = @token.strip if @token
      @api_environment = api_environment || self.class.api_environment || DEFAULT_API_ENVIRONMENT
      @api_endpoint = api_endpoint || self.class.api_endpoint
      @timeout = timeout || self.class.timeout || DEFAULT_TIMEOUT
      @open_timeout = open_timeout || self.class.open_timeout || DEFAULT_OPEN_TIMEOUT
      @proxy = proxy || self.class.proxy || ENV['VISMA_PROXY_URL']
      @faraday_adapter = faraday_adapter || Faraday.default_adapter
      @symbolize_keys = symbolize_keys || self.class.symbolize_keys || false
      @debug = debug || self.class.debug || false
      @logger = logger || self.class.logger || ::Logger.new(STDOUT)
    end

    def method_missing(method, *args)
      # To support underscores, we replace them with hyphens when calling the API
      @path_parts << method.to_s.gsub("_", "-").downcase
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end

    def send(*args)
      if args.length == 0
        method_missing(:send, args)
      else
        __send__(*args)
      end
    end

    def path
      @path_parts.join('/')
    end

    def create(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def update(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).put(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def retrieve(params: nil, headers: nil)
      APIRequest.new(builder: self).get(params: params, headers: headers)
    ensure
      reset
    end

    def delete(params: nil, headers: nil)
      APIRequest.new(builder: self).delete(params: params, headers: headers)
    ensure
      reset
    end

    protected

    def reset
      @path_parts = []
    end

    class << self
      attr_accessor :token, :timeout, :open_timeout, :api_environment, :api_endpoint, :proxy, :faraday_adapter, :symbolize_keys, :debug, :logger

      def method_missing(sym, *args, &block)
        new(token: self.token, api_environment: self.api_environment, api_endpoint: self.api_endpoint, timeout: self.timeout, open_timeout: self.open_timeout, faraday_adapter: self.faraday_adapter, symbolize_keys: self.symbolize_keys, debug: self.debug, proxy: self.proxy, logger: self.logger).send(sym, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        true
      end
    end
  end
end
