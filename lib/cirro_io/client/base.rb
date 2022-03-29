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

      # MonkeyPatch: https://github.com/JsonApiClient/json_api_client/issues/390
      # waiting for json_api_client to release a new version with the fix
      # https://github.com/JsonApiClient/json_api_client/pull/398
      # rubocop:disable all
      def initialize(params = {})
        params = params.with_indifferent_access
        @persisted = nil
        @destroyed = nil
        self.links = self.class.linker.new(params.delete(:links) || {})
        self.relationships = self.class.relationship_linker.new(self.class, params.delete(:relationships) || {})
        self.attributes = self.class.default_attributes.merge params.except(*self.class.prefix_params)
        self.forget_change!(:type)
        self.__belongs_to_params = params.slice(*self.class.prefix_params)

        setup_default_properties

        self.request_params = self.class.request_params_class.new(self.class)
      end
      # rubocop:enable all
    end
  end
end
