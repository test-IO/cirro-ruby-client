require 'forwardable'

module CirroIOV2
  module Errors
    class ClientError < StandardError
      extend Forwardable

      def_instance_delegators :@faraday_error, :response, :full_message

      attr_reader :faraday_error

      # this error class is intended to be used ONLY for 4xx errors
      # https://www.rubydoc.info/github/lostisland/faraday/Faraday/ClientError

      def initialize(faraday_error)
        @faraday_error = faraday_error
      end

      def message
        return faraday_error.response.inspect if ENV['DEBUG_CIRRO_RUBY_CLIENT']

        body = faraday_error.response&.dig(:body)
        result = body.presence || faraday_error.try(:message)
        result.is_a?(String) ? result : result.to_json
      end
    end
  end
end
