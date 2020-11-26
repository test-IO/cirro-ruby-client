module CirroIO
  module Client
    class Base < JsonApiClient::Resource
      self.route_format = :dasherized_route
      self.json_key_format = :dasherized_key

      # https://github.com/JsonApiClient/json_api_client/issues/215
      def self.site=(url)
        super(url)
        connection.faraday.url_prefix = url
      end

      def self.custom_post(endpoint, payload)
        custom_connection.post(endpoint, payload.to_json)
      end

      def self.custom_connection
        Faraday.new(url: "#{CirroIO::Client.configuration.site}/#{CirroIO::Client.configuration.api_version}") do |conn|
          conn.request :json
          conn.response :json
          conn.use CirroIO::Client::JwtAuthentication
          conn.use JsonApiClient::Middleware::Status, {}
        end
      end
    end
  end
end

CirroIO::Client::Base.connection do |connection|
  connection.use CirroIO::Client::JwtAuthentication
  connection.use Faraday::Response::Logger
  # connection.use CirroIO::Client::ResponseDebuggingMiddleware # This middleware can be injected during debugging or while adding new specs
end
