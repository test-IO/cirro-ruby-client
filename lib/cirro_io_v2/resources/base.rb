require 'active_support/core_ext/string/inflections'

module CirroIOV2
  module Resources
    class Base
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
    end
  end
end
