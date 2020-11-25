module CirroIO
  module Client
    module BulkActions
      class Base
        include CirroIO::Client::JwtTokenGenerator

        def self.headers
          { 'Authorization' => "Bearer #{self.new.generated_jwt_token}", 'Content-Type' => 'application/json' }
        end

        def self.full_url(endpoint)
          "#{CirroIO::Client.configuration.site}/#{CirroIO::Client.configuration.api_version}/bulk/#{endpoint}"
        end

        def self.post(endpoint, payload)
          Faraday.post(full_url(endpoint), payload.to_json, **headers)
        end
      end
    end
  end
end
