require 'jwt'
require 'openssl'

module CirroIOV2
  module RequestClients
    class Jwt < Base
      attr_reader :base_url, :private_key, :client_id, :connection

      def initialize(base_url:, private_key:, client_id:)
        # TODO: raise errors for wrong input
        @base_url = base_url
        @private_key = private_key
        @client_id = client_id

        @connection = Faraday.new(url: base_url) do |conn|
          conn.request :json
          conn.response :json
        end
      end

      def make_request(http_method, url, body: nil, params: nil, _headers: {})
        # TODO: why do you use underscore here?
        @connection.send(http_method, url) do |request|
          request.params = params if params
          request.body = body.to_json if body
          request.headers['Authorization'] = bearer_token
        end
      end

      def bearer_token
        payload = {
          exp: Time.now.to_i + (10 * 60),
          sub: client_id,
        }

        token = JWT.encode(payload, private_key, 'RS256')

        "Bearer #{token}"
      end
    end
  end
end
