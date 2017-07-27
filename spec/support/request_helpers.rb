module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end

    def response_attributes
      json_response[:data][:attributes]
    end

    def response_data
      json_response[:data]
    end

    def response_relationships
      json_response[:data][:relationships]
    end
  end

  module HeaderHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.api+json; version=#{version}"
    end

    def api_response_format(format = Mime[:json])
      request.headers['Accept'] = "#{request.headers['Accept']}"
      request.headers['Content-Type'] = "application/vnd.api+json"
    end

    def api_authorization_header(token)
      request.headers["Authorization"] = token
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end
end
