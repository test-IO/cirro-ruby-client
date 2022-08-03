module CirroIOV2
  module Resources
    class NotificationChannelPreference < Base
      ALLOWED_PARAMS = [:user_id, :notification_channel_id, :limit, :before, :after].freeze

      def list(params = nil)
        params_allowed?(params, ALLOWED_PARAMS) if params
        response_object(client.request_client.request(:get, resource_root, params: params))
      end
    end
  end
end
