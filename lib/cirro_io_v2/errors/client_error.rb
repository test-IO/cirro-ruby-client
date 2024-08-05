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
        puts faraday_error.response.inspect
        faraday_error.response.then do |response|
          return response.inspect if ENV.fetch('DEBUG_CIRRO_RUBY_CLIENT', false)

          faraday_error.response[:body].presence || faraday_error.try(:message)
        end
      end
    end
  end
end
