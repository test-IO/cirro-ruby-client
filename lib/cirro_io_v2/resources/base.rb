require 'active_support/core_ext/string/inflections'

module CirroIOV2
  module Resources
    class Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def resource_root
        self.class.name.demodulize.downcase.pluralize
      end
    end
  end
end
