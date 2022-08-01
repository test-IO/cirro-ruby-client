module CirroIOV2
  module Resources
    class NotificationBroadcast < Base
      ALLOWED_PARAMS = [:payload, :recipients, :notification_channel_id].freeze

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, resource_root, params))
      end
    end
  end
end
