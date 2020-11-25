module CirroIO
  module Client
    class JwtAuthentication < Faraday::Middleware
      include CirroIO::Client::JwtTokenGenerator

      def call(env)
        env[:request_headers]['Authorization'] = "Bearer #{generated_jwt_token}"
        @app.call(env)
      end
    end
  end
end
