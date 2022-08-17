module CirroIOV2
  module Resources
    class NotificationTopicPreference < Base
      ALLOWED_PARAMS = [:user_id, :notification_channel_id, :limit, :before, :after].freeze

      def resource_root
        'notification_channel_preferences'
      end

      def list(params = nil)
        params_allowed?(params, ALLOWED_PARAMS) if params
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationChannelPreferenceListResponse.new(response.body)
      end
    end
  end
end
