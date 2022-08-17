require 'forwardable'

module CirroIOV2
  module Errors
    class ResponseNotJsonError < StandardError
      extend Forwardable

      def_instance_delegators :@faraday_error, :message, :full_message, :response

      attr_reader :faraday_error

      def initialize(faraday_error)
        @faraday_error = faraday_error
      end
    end
  end
end
