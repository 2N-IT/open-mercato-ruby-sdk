module OpenMercato
  class Client
    def initialize(configuration)
      @configuration = configuration
    end

    def get(path, params = {})
      request(:get, path, params: transform_keys(params))
    end

    def post(path, body = {})
      request(:post, path, body: transform_keys(body))
    end

    def put(path, body = {})
      request(:put, path, body: transform_keys(body))
    end

    def delete(path, body = {})
      request(:delete, path, body: transform_keys(body))
    end

    private

    def request(method, path, params: nil, body: nil)
      response = connection.public_send(method, path) do |req|
        req.params = params if params
        req.body = JSON.generate(body) if body
      end

      handle_response(response)
    rescue Faraday::ConnectionFailed => e
      raise OpenMercato::Error, "Connection failed: #{e.message}"
    rescue Faraday::TimeoutError => e
      raise OpenMercato::Error, "Request timed out: #{e.message}"
    end

    def connection
      @connection ||= Faraday.new(url: @configuration.api_url) do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.headers["Accept"] = "application/json"
        conn.headers["x-api-key"] = @configuration.api_key
        conn.headers["X-Tenant-Id"] = @configuration.tenant_id if @configuration.tenant_id
        conn.headers["X-Organization-Id"] = @configuration.organization_id if @configuration.organization_id
        conn.headers["User-Agent"] = "open_mercato-ruby/#{OpenMercato::VERSION}"

        conn.request :retry,
          max: @configuration.retry_count,
          interval: 0.5,
          backoff_factor: 2,
          retry_statuses: [429, 502, 503, 504],
          methods: %i[get head options]

        conn.options.timeout = @configuration.timeout
        conn.options.open_timeout = @configuration.open_timeout

        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      body = parse_json(response.body)

      case response.status
      when 200..299
        body
      when 400
        raise ValidationError.from_response(body.is_a?(Hash) ? body : { "error" => response.body })
      when 401
        raise AuthenticationError, error_message(body, "Authentication failed")
      when 403
        raise ForbiddenError, error_message(body, "Forbidden")
      when 404
        raise NotFoundError, error_message(body, "Not found")
      when 429
        raise RateLimitError, error_message(body, "Rate limit exceeded")
      when 500..599
        raise ServerError, error_message(body, "Server error (#{response.status})")
      else
        raise Error, error_message(body, "Unexpected response (#{response.status})")
      end
    end

    def error_message(body, default)
      return default unless body.is_a?(Hash)
      body["error"] || body["message"] || default
    end

    def parse_json(body)
      return {} if body.nil? || body.to_s.empty?
      JSON.parse(body)
    rescue JSON::ParserError
      {}
    end

    def transform_keys(obj)
      case obj
      when Hash
        obj.each_with_object({}) do |(key, value), result|
          camel_key = key.to_s.gsub(/_([a-z])/) { $1.upcase }
          result[camel_key] = transform_keys(value)
        end
      when Array
        obj.map { |item| transform_keys(item) }
      else
        obj
      end
    end
  end
end