module CirroIOV2
  module Resources
    class NotificationLocale < Base
      ALLOWED_PARAMS = [:locale].freeze

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, resource_root, params))
      end

      def list
        response_object(client.request_client.request(:get, resource_root))
      end
    end
  end
end
