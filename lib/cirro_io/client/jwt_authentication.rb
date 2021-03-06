require 'jwt'
require 'openssl'

module CirroIO
  module Client
    class JwtAuthentication < Faraday::Middleware
      def call(env)
        private_pem = File.read(CirroIO::Client.configuration.private_key_path)
        private_key = OpenSSL::PKey::RSA.new(private_pem)

        payload = {
          # JWT expiration time (10 minute maximum)
          exp: Time.now.to_i + (10 * 60),
          # App client id
          iss: CirroIO::Client.configuration.app_id,
        }

        token = JWT.encode(payload, private_key, 'RS256')

        env[:request_headers]['Authorization'] = "Bearer #{token}"
        @app.call(env)
      end
    end
  end
end
