module CirroIO
  module Client
    class Base < JsonApiClient::Resource
      self.route_format = :dasherized_route
      self.json_key_format = :dasherized_key

      # HACK: https://github.com/JsonApiClient/json_api_client/issues/215
      # Used for initialization as well
      def self.site=(url)
        super.tap do
          connection true do |connection|
            connection.use JwtAuthentication
            connection.use Faraday::Response::Logger
            # connection.use ResponseDebuggingMiddleware # for debugging or while adding new specs
          end
        end
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
