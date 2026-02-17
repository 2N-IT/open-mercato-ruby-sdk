module OpenMercato
  module Testing
    module RequestStubs
      def stub_mercato_list(path, items:, **pagination)
        body = FakeResponses.collection(items, pagination)
        stub_request(:get, "#{base_url}#{path}")
          .to_return(status: 200, body: body.to_json, headers: json_headers)
      end

      def stub_mercato_find(path, id, response:)
        stub_request(:get, "#{base_url}#{path}/#{id}")
          .to_return(status: 200, body: response.to_json, headers: json_headers)
      end

      def stub_mercato_create(path, response: nil)
        response ||= FakeResponses.created_response
        stub_request(:post, "#{base_url}#{path}")
          .to_return(status: 201, body: response.to_json, headers: json_headers)
      end

      def stub_mercato_update(path)
        stub_request(:put, "#{base_url}#{path}")
          .to_return(status: 200, body: FakeResponses.ok_response.to_json, headers: json_headers)
      end

      def stub_mercato_destroy(path)
        stub_request(:delete, "#{base_url}#{path}")
          .to_return(status: 200, body: FakeResponses.ok_response.to_json, headers: json_headers)
      end

      def stub_mercato_error(path, status:, message: "Error", field_errors: {})
        body = FakeResponses.error_response(message, field_errors: field_errors)
        stub_request(:any, "#{base_url}#{path}")
          .to_return(status: status, body: body.to_json, headers: json_headers)
      end

      private

      def base_url
        OpenMercato.configuration.api_url
      end

      def json_headers
        { "Content-Type" => "application/json" }
      end
    end
  end
end