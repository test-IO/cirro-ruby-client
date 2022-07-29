require 'active_support/core_ext/string/inflections'

module CirroIOV2
  module Resources
    class Base < JsonApiClient::Resource
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def resource_root
        self.class.name.demodulize.underscore.pluralize
      end

      def params_allowed?(params, allowed)
        raise 'ParamNotAllowed' if (params.keys - allowed).any?
      end

      def response_object(response)
        JSON.parse(response[:body], object_class: OpenStruct)
      end
    end
  end
end
